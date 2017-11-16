/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lex;

/**
 *
 * @author Sosa
 */
public class ArryL {
 
    private String id;
    private String tipo;
    private String val;
 
    public ArryL(String id, String nom, String val){
        this.id = id;
        this.tipo  = nom;   
        this.val =val;
    }
 
    public String getId() {
        return id;
    }
 
    public String getTipo() {
        return tipo;
    }
 
    public void setTipo(String d) {
        this.tipo = d;        
    }
    public String getVal() {
        return val;
    }
 
    public void setVal(String d) {
        this.val = d;        
    }   
    
}