return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown", "ipynb" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
      "benlubas/molten-nvim",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "python", "bash", "r" },
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
        ft_runners = { python = "molten" },
        never_run = { "yaml" },
      },
    },
    config = function(_, opts)
      local quarto = require("quarto")
      quarto.setup(opts)

      local runner = require("quarto.runner")
      vim.keymap.set("n", "<leader>cq", function()
        runner.run_cell()
        vim.defer_fn(function()
          vim.cmd("MoltenEnterOutput")
        end, 800) -- Increased to 800ms for stability
      end, { desc = "Run Cell and Enter Output", silent = true })
      vim.keymap.set("n", "<leader>cQ", runner.run_all, { desc = "Run All Cells", silent = true })

      -- Keymap to insert a Python code block
      vim.keymap.set("n", "<leader>ip", function()
        -- Insert opening, newline, closing, then go up to the middle
        local keys = vim.api.nvim_replace_termcodes("o```{python}<cr>```<esc>O", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end, { desc = "Insert Python Cell" })

      -- Keymap to fix a missing closing tag
      vim.keymap.set("n", "<leader>ic", "o```<esc>", { desc = "Insert Closing Tag" })
    end,
  },

  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_win_max_height = 40
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = false -- DISABLED: No more text inside your code
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      vim.keymap.set("n", "<leader>mi", ":MoltenInit<cr>", { desc = "Molten Init", silent = true })
      vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<cr>", { desc = "Molten Eval", silent = true })
      vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<cr>", { desc = "Molten Eval Line", silent = true })
      vim.keymap.set("n", "<leader>rr", ":MoltenReEvaluateCell<cr>", { desc = "Molten Re-eval Cell", silent = true })
      vim.keymap.set("n", "<leader>rd", ":MoltenDelete<cr>", { desc = "Molten Delete", silent = true })
      vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<cr>", { desc = "Molten Hide Output", silent = true })
      vim.keymap.set("n", "<leader>os", ":MoltenShowOutput<cr>", { desc = "Molten Show Output", silent = true })
      vim.keymap.set("n", "<leader>oe", ":MoltenEnterOutput<cr>", { desc = "Molten Enter Output", silent = true })
    end,
  },

  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      max_width = 200, -- Increased to allow full width
      max_height = 50, -- Increased to allow full height
      max_width_window_percentage = 100,
      max_height_window_percentage = 100,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = function()
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "quarto", -- This replaces my previous manual autocmd
      })
    end,
  },
}
