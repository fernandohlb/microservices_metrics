package br.com.buzatof.imageProcess.service;

import java.awt.image.BufferedImage;
import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

import com.mongodb.gridfs.GridFSDBFile;

public interface ImageStorageServiceInterface {
	
	String storeMultiPartFile(String imageName, MultipartFile imageFile) throws IOException;
	
	void storeBufferedImage(String imageName, String contentType, BufferedImage bufferedImage) throws IOException;
	
	GridFSDBFile read(String imageName) throws IOException;

}
