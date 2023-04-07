local basePath = "~/notes"

local function askForName()
    vim.fn.inputsave()
    local name = vim.fn.input("Enter note name: ")
    vim.fn.inputrestore()
    return name
end

local function sNotesNew(name)
    local nonNullName
    if name == nil or name == "" then
        nonNullName = askForName()
    else
        nonNullName = name
    end
    local fileName = os.date("%Y-%m-%dT%H-%M-%S") .. nonNullName .. ".md"
    local fullPath = basePath .. "/" .. fileName
    local f = io.open(fullPath, "r")
    if f ~= nil then
        io.close(f)
        error("File already exists")
    else
        vim.cmd("saveas " .. fullPath)
    end
end

local function sNotesOpen()
    require("telescope.builtin").find_files({
        search_dirs = { basePath },
        search_file = ".md",
    })
end

local function sNotesSearch()
    require("telescope.builtin").live_grep({
        search_dirs = { basePath },
    })
end

vim.api.nvim_create_user_command(
    "SNotesNew",
    function(opts)
        sNotesNew(opts.args)
    end,
    {
        nargs = "?",
        desc = "Create a new note with the given name and the current timestamp",
    }
)

vim.api.nvim_create_user_command(
    "SNotesOpen",
    function()
        sNotesOpen()
    end,
    {
        nargs = 0,
        desc = "Open a Telescope search on all notes",
    }
)

vim.api.nvim_create_user_command(
    "SNotesSearch",
    function()
        sNotesSearch()
    end,
    {
        nargs = 0,
        desc = "Open a Telescope LiveGrep on all notes",
    }
)
