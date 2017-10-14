package br.com.buzatof.imageProcess.service;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.gridfs.GridFsCriteria;
import org.springframework.data.mongodb.gridfs.GridFsOperations;
import org.springframework.data.mongodb.gridfs.GridFsTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.gridfs.GridFSDBFile;

import br.com.buzatof.imageProcess.entity.Teste;
import br.com.buzatof.imageProcess.repository.TesteRepository;

@Service
public class ImageStoreService implements ImageStorageServiceInterface {
	
	@Autowired 
	private GridFsTemplate gridFsTemplate;
	
	@Autowired
	GridFsOperations gridOperations;
	
	@Autowired
	private TesteRepository testeRepository;

	@Override
	public void store(String imageName, MultipartFile imageFile) throws IOException{
		
		Optional<GridFSDBFile> arquivoExistente = verificaArquivoExistente(imageName);
		if (arquivoExistente.isPresent()) {
			gridFsTemplate.delete(consultaArquivoPorNome(imageName));
		}
		
		gridFsTemplate.store(imageFile.getInputStream(), imageName,imageFile.getContentType()).save();
		
	}
	
	@Override
	public GridFSDBFile read(String imageId) throws IOException{
		
		return consultaArquivoPorId(imageId);			
		
	}
	
	
	public void teste (String textoTeste) throws Exception {
		Teste teste = new Teste(textoTeste);
		testeRepository.save(teste);
		
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
