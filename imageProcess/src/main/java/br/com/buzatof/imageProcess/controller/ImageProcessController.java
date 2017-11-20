package br.com.buzatof.imageProcess.controller;

import java.awt.image.BufferedImage;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.gridfs.GridFsOperations;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.gridfs.GridFSDBFile;

import br.com.buzatof.imageProcess.service.ImageProcessServiceInterface;
import br.com.buzatof.imageProcess.service.ImageStorageServiceInterface;

@RestController
@RequestMapping("/api")

public class ImageProcessController {
	
	private final ImageStorageServiceInterface imageStorageService;
	private final ImageProcessServiceInterface imageProcessService;
	
	@Autowired
	GridFsOperations gridOperations;
	
    @Autowired
    public ImageProcessController(ImageStorageServiceInterface imageStorageService,ImageProcessServiceInterface imageProcessService) {
        this.imageStorageService = imageStorageService;
        this.imageProcessService = imageProcessService;
    }
	
	
    @PostMapping("/images")
    public String uploadFile(@RequestParam("file") MultipartFile imageFile) throws IOException{
    	String id = "";
    	if (imageFile.isEmpty()) {
            return "{\"status\":\"FILE-NOT-FOUND\",\"name\":\"\"\"id\":\"\"}\n";
        }
    	
    	try {
            id = imageStorageService.storeMultiPartFile(imageFile.getOriginalFilename(),imageFile);			
		} catch (IOException e) {
            return "{\"status\":\"NOK\",\"name\":\"\"\"id\":\"\"}\n";
        }

    	return "{\"status\":\"OK\",\"name\":\"" + imageFile.getOriginalFilename() + "\",\"id\":\"" + id +"\"}\n";
    }
    
    
    @GetMapping("/images/process/{id}")
    public String processImage(@PathVariable("id") String id){
    	
    	GridFSDBFile file;
		try {
			file = imageStorageService.read(id);
			
	    	if (file == null) {
	            return "{\"status\":\"FILE-NOT-FOUND\",\"name\":\"\"\"id\":\"\"}\n";
	        }
	    	
		} catch (IOException e1) {
			return "{\"status\":\"NOK\",\"name\":\"\"\"id\":\"\"}\n";
		}
    	
    	try {
			
			String nameImageBlur = imageProcessService.renameFileToBlur(file.getFilename());
			String contentType = file.getContentType();
			
			//Processa o Arquivo			
			BufferedImage imageBlur = imageProcessService.blur(file);
			
			imageStorageService.storeBufferedImage(nameImageBlur, contentType, imageBlur);
			
		} catch (IOException e) {
			return "{\"status\":\"PROCESS-NOK\",\"name\":\"\"\"id\":\"\"}\n";
		}
    	
    	return "{\"status\":\"OK\",\"name\":\"\"\"id\":\""+ id + "\"}\n";
    }
    
    
    //Apagar - Apenas Teste
    @GetMapping("/images/{id}")
	public String retrieveImageFile(@PathVariable("id") String id) throws IOException{
		// read file from MongoDB
		GridFSDBFile file = imageStorageService.read(id);
		
		// Save file back to local disk
		file.writeTo("out.png");
		
		System.out.println("Image File Name:" + file.getFilename());
		
		return "Done";
	}
    
 
}
