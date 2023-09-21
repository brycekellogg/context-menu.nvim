local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")


-- what is M?
local M = {}

-- Git Actions
--   Buffer:
--      - Add Chunk
--      - Diff Chunk
--      - Unstage Chunk

-- LSP Actions
--    - Refactor
--    - Find References
--    - Go to Definition
--    - 


-- Setup function
--
--
function M.setup(opts)

    -- ???
    opts = opts or {}

    -- Get default config
    M.config = require('context-menu.config')

    -- Load item configs and merge with default config
    M.config = vim.tbl_deep_extend('error', M.config, require('context-menu.items.neotree'))
    M.config = vim.tbl_deep_extend('error', M.config, require('context-menu.items.gitsigns'))

    -- Load telescope theme and merge with default config
    local telescopeConfig = require("telescope.themes").get_dropdown({layout_config={width=0.3}})
    M.config = vim.tbl_deep_extend('error', M.config, telescopeConfig)

    -- Combine the default configuration with the options passed
    -- via the plugin manager. Use the passed in options if
    -- there is a conflict so we can override configuration.
    M.config = vim.tbl_deep_extend('force', M.config, opts)

    -- vim.api.nvim_echo({{vim.inspect(M.config)}}, true, {})

end


-- to execute the function
--
-- TODO get current buffer number here
-- then build finder (statically) using that buffer number
-- (passed in via opts) to filter.
function M.menu(opts)

    opts = opts or {}
    -- TODO: merge M.config into opts

    -- Get info about menu context
    opts.win_id = "???"
    opts.buf_id = vim.api.nvim_get_current_buf()
    opts.buf_filetype = vim.bo.filetype


    -- Built items list
    -- Telescope uses order of this,
    -- need to sort based on something
    local items = {}
    local i = 0
    for _,v in pairs(M.config.items) do
        i = i + 1
        items[i] = v
    end

    -- why do we do sort?
    table.sort(items, function (a, b)
        return a.display < b.display
    end)

    -- vim.api.nvim_echo({{vim.inspect(items)}}, true, {})

    -- Define the static finder
    local finder = finders.new_table({
        results = items,
        entry_maker = function (entry)
            -- Each menu item gets to decide if it is valid
            -- via a callback function. This can be overridden
            -- by using false instead of a function.
            local valid = entry.enable
            if type(valid) == "function" then
                valid = valid(opts)
            end

            -- This is what telescope needs
            return {
                value   = entry,
                display = entry.display,  -- string that gets displayed by Telescope
                ordinal = entry.display,  -- how Telescope sorts entries
                valid   = valid,          -- true to show, false to hide
                action  = entry.action,   -- a function to call when selected
            }
        end
    })

    -- Define the picker
    local picker = pickers.new(M.config, {
        prompt_title = M.config.title,
        finder = finder,
        cache_picker = false,  -- no caching because of how we enable items
        sorter = conf.generic_sorter(M.config),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                selection.action()
            end)
            return true
        end,
    })

    -- Call the picker, this shows the menu
    picker:find(opts)
end

-- Why do we return M?
return M
