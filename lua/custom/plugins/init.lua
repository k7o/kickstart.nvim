-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'github/copilot.vim',
  },
  {
    'b0o/schemastore.nvim',
  },
  {
    'tpope/vim-commentary',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
  },
  {
    -- 'some-stole-my-name' is the official repo, but contains deprecated references, this is fixed in 'mosheavni's repo.
    -- 'someone-stole-my-name/yaml-companion.nvim',
    'mosheavni/yaml-companion.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- https://www.arthurkoziel.com/json-schemas-in-neovim/
      -- https://github.com/datreeio/CRDs-catalog
      -- https://github.com/b0o/SchemaStore.nvim/blob/main/lua/schemastore/catalog.lua
      local cfg = require('yaml-companion').setup {
        builtin_matchers = {
          kubernetes = { enabled = true },
        },
        schemas = {
          -- not loaded automatically, manually select with
          -- :Telescope yaml_schema
          {
            name = 'helm.toolkit.fluxcd.io helmrelease_v2',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/helm.toolkit.fluxcd.io/helmrelease_v2.json',
          },
          {
            name = 'kustomize.toolkit.fluxcd.io kustomization_v2',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/kustomize.toolkit.fluxcd.io/kustomization_v1.json',
          },
          {
            name = 'source.toolkit.fluxcd.io gitrepository_v1',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/gitrepository_v1.json',
          },
          {
            name = 'source.toolkit.fluxcd.io helmchart_v1',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/helmchart_v1.json',
          },
          {
            name = 'source.toolkit.fluxcd.io helmrepository_v1',
            uri = 'hhttps://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/helmrepository_v1.json',
          },
          {
            name = 'source.toolkit.fluxcd.io ocirepository_v1beta2',
            uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/source.toolkit.fluxcd.io/ocirepository_v1beta2.json',
          },
          -- schemas below are automatically loaded, but added
          -- them here so that they show up in the statusline
          {
            name = 'Kustomization',
            uri = 'https://json.schemastore.org/kustomization.json',
          },
          {
            name = 'GitHub Workflow',
            uri = 'https://json.schemastore.org/github-workflow.json',
          },
          {
            name = 'Azure Pipelines',
            uri = 'https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json',
          },
        },
        lspconfig = {
          settings = {
            yaml = {
              validate = true,
              schemaStore = {
                enable = false,
                url = '',
              },

              -- schemas from store, matched by filename
              -- loaded automatically
              schemas = require('schemastore').yaml.schemas {
                select = {
                  'kustomization.yaml',
                  'GitHub Workflow',
                  'Azure Pipelines',
                },
              },
            },
          },
        },
      }

      require('lspconfig')['yamlls'].setup(cfg)
      require('telescope').load_extension 'yaml_schema'
      -- get schema for current buffer
      local function get_schema()
        local schema = require('yaml-companion').get_buf_schema(0)
        if schema.result[1].name == 'none' then
          return ''
        end
        return schema.result[1].name
      end
      require('lualine').setup {
        sections = {
          lualine_x = { 'fileformat', 'filetype', get_schema },
        },
      }
    end,
  },
}
