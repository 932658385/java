import React, { useState } from 'react';
import Modal from 'react-modal';
import './Modal.css'; // Importa o arquivo CSS de estilos

const LoginCadastroModal = ({ onLoginSuccess }) => {
  const [modalIsOpen, setModalIsOpen] = useState(true);
  const [isLoginForm, setIsLoginForm] = useState(true); // Estado para controlar se é o formulário de login ou cadastro

  const handleCloseModal = () => {
    setModalIsOpen(false);
  };

  const handleLogin = () => {
    // Lógica de login aqui
    // Após o login bem-sucedido, chame a função onLoginSuccess
    onLoginSuccess();
    // Feche o modal
    handleCloseModal();
  };

  const handleSwitchForm = () => {
    // Alternar entre o formulário de login e cadastro
    setIsLoginForm(!isLoginForm);
  };

  const handleFormSubmit = (event) => {
    event.preventDefault();
    if (isLoginForm) {
      handleLogin();
    } else {
      // Lógica de cadastro aqui
      // Feche o modal após o cadastro bem-sucedido
      handleCloseModal();
    }
  };

  return (
    <Modal
      isOpen={modalIsOpen}
      onRequestClose={handleCloseModal}
      className="modal-content" // Adiciona a classe CSS para estilizar o conteúdo do modal
      overlayClassName="modal-overlay" // Adiciona a classe CSS para estilizar o overlay do modal
      contentLabel="Login e Cadastro"
    >
      <div className="modal-wrapper">
        <div className="modal-inner">
          {isLoginForm ? <h2>Login</h2> : <h2>Cadastro</h2>}
          <form onSubmit={handleFormSubmit}>
            {!isLoginForm && (
              <>
                <div className="form-group">
                  <label htmlFor="nome">Nome:</label>
                  <input type="text" id="nome" required />
                </div>
                <div className="form-group">
                  <label htmlFor="sobrenome">Sobrenome:</label>
                  <input type="text" id="sobrenome" required />
                </div>
              </>
            )}
            <div className="form-group">
              <label htmlFor="email">Email:</label>
              <input type="email" id="email" required />
            </div>
            <div className="form-group">
              <label htmlFor="password">Senha:</label>
              <input type="password" id="password" required />
            </div>
            {!isLoginForm && (
              <div className="form-group">
                <label htmlFor="confirmPassword">Confirmar Senha:</label>
                <input type="password" id="confirmPassword" required />
              </div>
            )}
          </form>
          <div className="button-container">
            <a href="#" className="modal-link-button" onClick={handleFormSubmit}>
              {isLoginForm ? 'Login' : 'Cadastrar'}
            </a>
          </div>
          <p>
            {isLoginForm ? (
              <>
                Ainda não tem uma conta?{' '}
                <a href="#" className="modal-link-button" onClick={handleSwitchForm}>
                  Cadastre-se aqui
                </a>
              </>
            ) : (
              <>
                Já possui uma conta?{' '}
                <a href="#" className="modal-link-button" onClick={handleSwitchForm}>
                  Faça login aqui
                </a>
              </>
            )}
          </p>
        </div>
      </div>
    </Modal>
  );
};

export default LoginCadastroModal;
