import React from 'react';
import './Footer.css'; // Importando o arquivo CSS

const Footer = () => {
  return (
    <footer className="footer-container">
      <div className="footer-col">
        <h3>HospedaPro</h3>
        <p>&#169; 2024 HospedaPro, todos os direitos reservados</p>
      </div>
      <div className="footer-col">
        <h3>Contato</h3>
        <p>Telefone: <a href="tel:xx-xxxxx-xxxx">(+244) 946 179 460</a></p>
        <p>Email: <a href="mailto:exemplo@example.com">hospedapro@gmail.com</a></p>
      </div>
      <div className="footer-col">
        <h3>Ajuda</h3>
        <p>Se precisar de ajuda, entre em contato conosco.</p>
      </div>
      <div className="footer-col">
        <h3>Suporte</h3>
        <p>Para assistência técnica, entre em contato com nosso suporte.</p>
      </div>
      <div className="footer-col">
        <h3>Termos e Condições</h3>
        <p>Leia nossos <a href="/termos-e-condicoes">termos e condições</a> para saber mais.</p>
      </div>
    </footer>
  );
};

export default Footer;
