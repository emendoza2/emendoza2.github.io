function setupAutoGist()
    saveProjectData("Version",VERSION)
    saveProjectData("Project Name",PROJECTNAME)
    saveProjectData("Decription",DESCRIPTION)
    saveProjectData("Author",AUTHOR)
    
    -- AutoGist (DO NOT EDIT!)
    if AutoGist then
        a = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
        a:backup() 
    end
    if not readGlobalData("em2iPad") then
        local tabText = readProjectTab("Main")
        tabText = tabText:gsub("%-%-%[DELETE%]%-%-.-%-%-%[/DELETE%]%-%-","")
        saveProjectTab("Main",tabText)
        saveProjectTab("Delete",nil)
    end
end
