# Vue

## Setup

- install vue/typescript plugin

```bash
npm i -g @vue/typescript-plugin
```

- find where it was installed
  When using nvm the path will be `/home/{user}/.nvm/versions/node/{version}/node_modules/@vue/typescript-plugin`

- Then just add it to tsserver config

```lua
require'lspconfig'.tsserver.setup{
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}
```
