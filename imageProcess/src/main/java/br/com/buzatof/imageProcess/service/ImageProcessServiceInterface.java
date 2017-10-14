package br.com.buzatof.imageProcess.service;

import java.io.IOException;

import com.mongodb.gridfs.GridFSDBFile;

public interface ImageProcessServiceInterface {
	
	void blur (GridFSDBFile file)throws IOException;

}
