function downloadImageToProject(imageName,source)
    if not readImage("Project:"..imageName) then
        print("Attempting to download "..imageName.."...")
        http.request(source,function(img,status,headers) 
            saveImage("Project:"..imageName,img) 
            print("Success!") 
        end, function(err) 
            print(err.."\nFailed to get image. Your project may not work properly.") 
        end)
    end
end
