package br.com.buzatof.imageProcess.service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.gridfs.GridFsCriteria;
import org.springframework.data.mongodb.gridfs.GridFsOperations;
import org.springframework.data.mongodb.gridfs.GridFsTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.gridfs.GridFSDBFile;

@Service
public class ImageStoreService implements ImageStorageServiceInterface {
	
	@Autowired 
	private GridFsTemplate gridFsTemplate;
	@Autowired
	GridFsOperations gridOperations;
	
	
	@Override
	public String storeMultiPartFile(String imageName, MultipartFile imageFile) throws IOException{
		
		deletaArquivoExistente(imageName);
		
		com.mongodb.gridfs.GridFSFile file = gridFsTemplate.store(imageFile.getInputStream(),imageName,imageFile.getContentType());
		
		file.save();
		
		return file.getId().toString();
		
		//gridFsTemplate.store(imageFile.getInputStream(), imageName,imageFile.getContentType()).save();
		
	}
	
	@Override
	public void storeBufferedImage(String imageName, String contentType, BufferedImage bufferedImage) throws IOException{
		
		deletaArquivoExistente(imageName);		
		gridFsTemplate.store(bufferedImageToInputStream(bufferedImage), imageName,contentType).save();
		
		
	}

	private void deletaArquivoExistente(String imageName) {
		Optional<GridFSDBFile> arquivoExistente = verificaArquivoExistente(imageName);
		if (arquivoExistente.isPresent()) {
			gridFsTemplate.delete(consultaArquivoPorNome(imageName));
		}
	}

	@Override
	public GridFSDBFile read(String imageId) throws IOException{
		
		return consultaArquivoPorId(imageId);			
		
	}
	
	
	
	private static InputStream bufferedImageToInputStream (BufferedImage image) throws IOException {
		ByteArrayOutputStream os = new ByteArrayOutputStream(); 
		
		ImageIO.write(image,"png", os); 
		InputStream is = new ByteArrayInputStream(os.toByteArray());
		
		return is;
	}
	
	
	private Optional<GridFSDBFile> verificaArquivoExistente(String name) {
	    GridFSDBFile file = gridFsTemplate.findOne(consultaArquivoPorNome(name));
	    return Optional.ofNullable(file);
	  }
	
	private GridFSDBFile consultaArquivoPorId(String id) {
		GridFSDBFile imageFile = gridOperations.findOne(new Query(Criteria.where("_id").is(id)));
		return imageFile;
	}
	
	private static Query consultaArquivoPorNome(String name) {
	    return Query.query(GridFsCriteria.whereFilename().is(name));
	}	

}
