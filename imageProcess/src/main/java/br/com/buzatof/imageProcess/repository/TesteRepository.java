package br.com.buzatof.imageProcess.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import br.com.buzatof.imageProcess.entity.Teste;

public interface TesteRepository extends MongoRepository<Teste,String> {

}
