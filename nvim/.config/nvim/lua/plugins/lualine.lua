return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local function molten_kernel()
        local ok, molten = pcall(require, "molten.status")
        if not ok then
          return ""
        end
        -- molten.status.initialized() returns the kernel name
        local kernel = molten.initialized()
        if kernel and kernel ~= "" then
          return "󱐋 " .. kernel
        end
        return ""
      end

      -- Ensure sections and lualine_x exist
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      -- Add to the beginning of lualine_x
      table.insert(opts.sections.lualine_x, 1, {
        molten_kernel,
        color = { fg = "#76946A", gui = "bold" },
      })
    end,
  },
}
