package br.com.buzatof.imageProcess.repository;


import org.springframework.data.repository.PagingAndSortingRepository;

import br.com.buzatof.imageProcess.entity.Images;

public interface ImagesRepository extends PagingAndSortingRepository<Images,String>{
	
}
