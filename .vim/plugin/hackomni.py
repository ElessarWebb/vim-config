###########################################################################
#  Copyright 2012-2013 Facebook.
#
#  Licensed under the Apache License, Version 2.0 (the #License#);
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an #AS IS# BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################

# HackForHipHop Vim-OmniComplete v0.2

import vim
import re
from subprocess import Popen, PIPE

class Const(object):
    CLIENT = r'hh_client'
    REPO = r'~/www'
    DEBUG = False

class Util(object):
    @staticmethod
    def debugf(name, d):
        if not Const.DEBUG:
            return
        debugf = "\n------------------------\n".join(
                [repr(k) + " => " + repr(v) for k,v in d.iteritems()])
        fp = file("/tmp/omnihackdbg-" + name, "w")
        fp.write(debugf)
        fp.close()

class HackOmniComplete(object):
    """
        Find the first non completable character. Not very smart.
        Works on a reversed line.
    """
    matcher = re.compile("^([\w$]+)(.*)$")

    def __init__(self, findstart, base):
        self.findstart = findstart
        self.base = base

    # This thing will pipe the buffer to hh_client, and return its output
    def getLines(self):
      lines = [str(line) for line in vim.current.buffer]
      (row, col) = vim.current.window.cursor
      cur_line = lines[row-1]
      cur_line = cur_line[:col] + self.base + "AUTO332" + cur_line[col:]
      lines[row-1] = cur_line
      input_buffer = "\n".join(lines)

      # Send the buffer to hh_client and return the lines
      args = [
        Const.CLIENT,
        Const.REPO,
        r'--auto-complete'
      ]
      proc = Popen(args, stdin=PIPE, stdout=PIPE, stderr=PIPE)
      proc.stdin.write(input_buffer);
      out = proc.communicate()[0]

      base = self.base

      try:
        proc.kill();
      except:
        pass
      proc = args = None
      Util.debugf('getLines.txt', locals())

      return [x for x in out.split("\n") if len(x) > 0]

    # This thing will parse all hh_client lines into dictionaries
    def getDicts(self, lines):
      res = []
      for line in lines:
        space = line.find(' ')
        word = None
        menu = None
        kind = None
        if line[0] == '$':
          # Hacky assumption that this is all a variable name
          name_end = len(line)
          if space != -1:
            name_end = space
          word = line[:name_end]
          if not word.startswith(self.base):
            continue
          menu = line[name_end:]
          kind = 'v'
        elif space < 0:
          # looks like a class name!
          word = line
          menu = '' # TODO: add info here!!! class/interface/trait
          if not word.startswith(self.base):
            continue
          kind = 'c' # vim likes "t" better, but I'll keep that for trait
        else:
          # function or constant or $this->something
          word = line[:space]
          if not word.startswith(self.base):
            continue
          menu = line[space+1:]
          if menu.find('(function(') >= 0:
            kind = 'f'
          else:
            # Umm, so, this can be a constant OR a field, as in
            # $this->AUTO332 (variables will start without $)
            # so I'll just use 'v' here.
            kind = 'v'

        res.append({'word': word, 'menu': menu, 'kind': kind})
      return res

    # This thing will transform a python dictionary to a vim dictionary
    def toVimDictionaryString(self, d):
      buffer = []
      for k, v in d.iteritems():
        buffer.append("'%s': '%s'" % (k, v))
      return '{' + ",".join(buffer) + '}'

    # This thing does the autocomplete.
    # Wires the getLines -> getDicts -> toVimDictionaryString
    def completeMain(self):
      lines = self.getLines()
      dicts = self.getDicts(lines)
      vim_res = '[' + ",".join([self.toVimDictionaryString(x) for x in dicts]) + ']'
      Util.debugf('completeMain.txt', locals())
      vim.command('return %s' % vim_res)

    def findMain(self):
      (row, col) = vim.current.window.cursor
      # Get the current line, up to "col" index, and then reverse it
      line = str(vim.current.buffer[row-1])[:col][::-1]
      # Match all characters until we reach something that's not a name character
      sre = self.matcher.search(line)
      org_start = len(line)
      decrement = 0
      if sre is not None:
        decrement = len(sre.groups()[0])

      start = org_start - decrement
      Util.debugf('findMain.txt', locals())
      vim.command('return ' + str(start))

    # Entry point
    def main(self):
      if self.findstart:
        self.findMain()
      else:
        self.completeMain()

