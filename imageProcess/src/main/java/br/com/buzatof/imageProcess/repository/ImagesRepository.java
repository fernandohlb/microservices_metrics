package br.com.buzatof.imageProcess.repository;


import org.springframework.data.mongodb.repository.MongoRepository;

import br.com.buzatof.imageProcess.entity.Images;

public interface ImagesRepository extends MongoRepository<Images,String>{
	
}
