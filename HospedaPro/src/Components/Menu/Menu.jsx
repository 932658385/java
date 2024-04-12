import React, { useState } from 'react';
import './Menu.css';
import logo_hosp from '../../assets/img/logo_hosp.jpg'
import logo_leve from '../../assets/img/logo-black.png'
import logo_escuro from '../../assets/img/logo-white.png'
import icone_de_busca_leve from '../../assets/img/search-w.png'
import icone_de_busca_escuro from '../../assets/img/search-b.png'
import alternar_claro from '../../assets/img/night.png'
import alternar_escuro from '../../assets/img/day.png'
        

const Menu = ({ tema, setTema }) => {
  const [menuAberto, setMenuAberto] = useState(false);

  const Modo_de_alternancia = () => {
    tema === 'light' ? setTema('dark') : setTema('light');
  };

  const toggleMenu = () => {
    setMenuAberto(!menuAberto);
  };

  return (
    <div className={`menu ${menuAberto ? 'active' : ''}`}>
      <img src={tema === 'light' ? logo_leve : logo_escuro} alt="" className='logo' /><br/>

      <ul className={menuAberto ? 'active' : ''}>
        <li><a href="#">Pagina Inicial</a></li> 
        <li><a href="#">Deposito</a></li>  
      </ul>

      <div className="Caixa-de-busca">
        <input type="text" placeholder='Buscar Hospedarias'/>
        <img src={tema === 'light' ? icone_de_busca_leve : icone_de_busca_escuro} alt="" />
      </div>

      <img onClick={Modo_de_alternancia} src={tema === 'light' ? alternar_claro : alternar_escuro} alt="" className='
icone-de-alternancia'/>

      <button onClick={toggleMenu}>&#9776;</button>
      <li><a href="">Sair</a></li>  
    </div>
  );
};

export default Menu;