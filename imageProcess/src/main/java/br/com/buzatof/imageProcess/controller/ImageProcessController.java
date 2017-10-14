package br.com.buzatof.imageProcess.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.gridfs.GridFsOperations;
import org.springframework.data.mongodb.gridfs.GridFsResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
    	
    	if (imageFile.isEmpty()) {
            return "Por favor, selecione um Arquivo de Imagem!\n";
        }
    	
    	try {
            imageStorageService.store(imageFile.getOriginalFilename(),imageFile);			
		} catch (IOException e) {
            return "Erro ao Gravar a Imagem na Base de Dados";
        }

    	return "Upload realizado com sucesso - " + imageFile.getOriginalFilename() + "\n";
    }
    
    
    @GetMapping("/images/process/{id}")
    public String processImage(@PathVariable("id") String id){
    	
    	GridFSDBFile file;
		try {
			file = imageStorageService.read(id);
			
	    	if (file == null) {
	            return "Arquivo "+ id + "não encontrado\n";
	        }
	    	
		} catch (IOException e1) {
			return "Erro ao Ler a Imagem na Base de Dados\n";
		}
    	
    	try {
			imageProcessService.blur(file);
		} catch (IOException e) {
			return "Erro ao Processar a Imagem na Base de Dados\n";
		}
    	
    	return "Processamento do arquivo realizado com sucesso\n";
    }
    
    
    //Apagar - Apenas Teste
    @GetMapping("/images/{id}")
	public String retrieveImageFile(@PathVariable("id") String id) throws IOException{
		// read file from MongoDB
		GridFSDBFile imageFile = gridOperations.findOne(new Query(Criteria.where("_id").is(id)));
		
		// Save file back to local disk
		imageFile.writeTo("out.png");
		
		System.out.println("Image File Name:" + imageFile.getFilename());
		
		return "Done";
	}
    
 
}
