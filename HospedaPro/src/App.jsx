import React, { useState, useEffect } from 'react';
import LoginCadastroModal from './Components/LoginCadastroModal/LoginCadastroModal';
import Menu from './Components/Menu/Menu';
import Footer from './Components/Footer/Footer';

const App = () => {
  const tema_atual = localStorage.getItem('tema_atual');
  const [tema, setTema] = useState(tema_atual ? tema_atual : 'light');
  const [isLoggedIn, setIsLoggedIn] = useState(false); // Estado para controlar se o usuário está logado

  useEffect(() => { 
    localStorage.setItem('tema_atual', tema);
  }, [tema]);

  // Função para lidar com o login bem-sucedido
  const handleLoginSuccess = () => {
    setIsLoggedIn(true); // Define isLoggedIn como true após o login bem-sucedido
  };

  return (
    <div className={`container ${tema}`}>
      {/* Renderiza o componente Menu se o usuário estiver logado, senão, renderiza o LoginCadastroModal */}
      {isLoggedIn ? <Menu tema={tema} setTema={setTema} /> : <LoginCadastroModal onLoginSuccess={handleLoginSuccess} />}
      <Footer />
    </div>
  );
};

export default App;