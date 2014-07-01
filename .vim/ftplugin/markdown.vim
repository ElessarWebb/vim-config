noremap <leader>m :!rm -rf /tmp/vim.markdown.tmp && generate-md --layout mixu-page --input % --output /tmp/vim.markdown.tmp && firefox /tmp/vim.markdown.tmp/*.html<NL>
