package br.com.buzatof.imageProcess.service;

import java.awt.image.BufferedImage;
import java.io.IOException;

import com.mongodb.gridfs.GridFSDBFile;

public interface ImageProcessServiceInterface {
	
	BufferedImage blur(GridFSDBFile file) throws IOException;
	
	public String renameFileToBlur(String fileName);

}
