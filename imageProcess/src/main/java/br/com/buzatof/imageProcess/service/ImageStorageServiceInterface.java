package br.com.buzatof.imageProcess.service;

import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

import com.mongodb.gridfs.GridFSDBFile;

public interface ImageStorageServiceInterface {
	
	void store(String imageName, MultipartFile imageFile) throws IOException;
	
	GridFSDBFile read(String imageName) throws IOException;

	void teste(String textoTeste) throws Exception;
	
}
