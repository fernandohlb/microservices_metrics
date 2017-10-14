package br.com.buzatof.imageProcess.entity;

import org.springframework.data.annotation.Id;

public class Teste {
	 @Id
	 public String id;
	 
	 public String textoTeste;
	 
	 public Teste (String textoTeste) {
		 this.textoTeste = textoTeste;
	 }
	 
}
