package br.com.buzatof.imageProcess.entity;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.web.multipart.MultipartFile;

@Document(collection = "images-process")
public class Images {
	
	 @Id
	 public String id;
	 
	 public String imageName;
	 
	 public InputStream imageFile;
	 	 
	 public Images (String imageName, MultipartFile imageFile) throws IOException {
		 this.imageName = imageName;
		 this.imageFile = imageFile.getInputStream();
	 }

}
