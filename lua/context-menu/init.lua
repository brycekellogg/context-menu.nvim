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


-- ???
--
--
local function entry_maker(entry)

    -- Each menu item gets to decide if it is valid
    -- via a callback function. This can be overridden
    -- by using false instead of a function.
    local valid = entry.enable
    if type(valid) == "function" then
        valid = valid()
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


-- Setup function
--
--
function M.setup(opts)

    -- Get default config
    local defaultConfig = require('context-menu.config')
    defaultConfig = vim.tbl_deep_extend('force', require('context-menu.items.neotree'), defaultConfig)

    -- Combine the default configuration with the options passed
    -- via the plugin manager. Use the passed in options if
    -- there is a conflict so we can override configuration.
    opts = vim.tbl_deep_extend('force', defaultConfig, opts)

    -- vim.api.nvim_echo({{vim.inspect(opts)}}, true, {})

    -- Built items list
    local items = {}
    local i = 0
    for _,v in pairs(opts.items) do
        i = i + 1
        items[i] = v
    end

    -- Define the static finder
    local finder = finders.new_table({
        results = items,
        entry_maker = entry_maker
    })

    -- Define the picker
    M.picker = pickers.new(opts.picker, {
        prompt_title = opts.title,
        finder = finder,
        sorter = conf.generic_sorter(opts.picker),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                selection.action()
            end)
            return true
        end,
    })
end


-- to execute the function
--
function M.menu()
    M.picker:find()
end

-- Why do we return M?
return M
