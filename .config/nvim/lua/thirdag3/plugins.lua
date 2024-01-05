local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "projekt0n/github-nvim-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = require("thirdag3.config.theme")
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = require("thirdag3.config.treesitter")
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
          { "williamboman/mason.nvim", config = true },
          "williamboman/mason-lspconfig.nvim"
        }
    },
    {
       "hrsh7th/nvim-cmp"
    },
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
        end
    }
}

require("lazy").setup(plugins)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})

require("mason").setup()
require("mason-lspconfig").setup()

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
    ensure_installed = {
       "lua_ls", "rust_analyzer", "omnisharp"
    }
}


local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

lspconfig["lua_ls"].setup {
    settings = {
        Lua = {
            capabilities = capabilities
        }
        -- Lua = {
        --     -- on_attach = function(_, _)
        --         -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        --     -- end
        --     capabilities = capabilities
        -- }
    }
}


lspconfig["rust_analyzer"].setup({
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enable = true
            }
        }
    }
})


lspconfig["omnisharp"].setup({
    settings = {
    }
})

local luasnip = require("luasnip")

local cmp = require "cmp"
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
    ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }
}
