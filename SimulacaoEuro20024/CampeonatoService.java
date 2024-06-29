import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

public class CampeonatoService {
    private PaisDAO paisDAO;
    private JogadorDAO jogadorDAO;
    private JogoDAO jogoDAO;
    private EstatisticasJogoDAO estatisticasJogoDAO;
    private List<Grupo> grupos;
    private List<Pais> paises;
    private int minEquipes = 24;
    private int maxEquipes = 24;
    private int jogadoresPorEquipe = 18;
    private int numGrupos = 6;
    private int equipesPorGrupo = 4;

    public CampeonatoService(PaisDAO paisDAO, JogadorDAO jogadorDAO, JogoDAO jogoDAO, EstatisticasJogoDAO estatisticasJogoDAO) {
        this.paisDAO = paisDAO;
        this.jogadorDAO = jogadorDAO;
        this.jogoDAO = jogoDAO;
        this.estatisticasJogoDAO = estatisticasJogoDAO;
        this.grupos = new ArrayList<>();
        this.paises = new ArrayList<>();
        // Inicialize outros DAOs...
    }

    public void adicionarPais(Pais pais) throws SQLException {
        if (paises.size() >= maxEquipes) {
            throw new IllegalStateException("Número máximo de equipes atingido");
        }
        paisDAO.adicionarPais(pais);
        paises.add(pais);
    }

    public Optional<Pais> obterPaisPorId(int id) throws SQLException {
        return paisDAO.obterPaisPorId(id);
    }

    public void adicionarJogador(Jogador jogador) throws SQLException {
        long jogadoresEquipe = jogadorDAO.obterJogadoresPorPais(jogador.getPais().getId()).size();
        if (jogadoresEquipe >= jogadoresPorEquipe) {
            throw new IllegalStateException("Número máximo de jogadores por equipe atingido");
        }
        jogadorDAO.adicionarJogador(jogador);
    }

    public List<Jogador> obterJogadoresPorPais(int paisId) throws SQLException {
        return jogadorDAO.obterJogadoresPorPais(paisId);
    }

    public List<Jogador> obterMelhoresMarcadores() throws SQLException {
        return jogadorDAO.obterMelhoresMarcadores();
    }

    public void atualizarEstatisticasJogo(EstatisticasJogo estatisticas) throws SQLException {
        estatisticasJogoDAO.atualizarEstatisticasJogo(estatisticas);
        // Atualize classificações, artilheiros, etc.
    }

    public void criarGrupos() {
        if (paises.size() < minEquipes) {
            throw new IllegalStateException("Número mínimo de equipes não atingido");
        }
        Collections.shuffle(paises);
        for (int i = 0; i < numGrupos; i++) {
            List<Pais> selecoes = paises.subList(i * equipesPorGrupo, (i + 1) * equipesPorGrupo);
            grupos.add(new Grupo(i + 1, "Grupo " + (char)('A' + i), selecoes));
        }
    }

    public void classificarEquipes() {
        List<Pais> qualificados = new ArrayList<>();
        List<Pais> terceirosColocados = new ArrayList<>();

        for (Grupo grupo : grupos) {
            grupo.getSelecoes().sort(Comparator.comparingInt(this::calcularPontos).reversed());
            qualificados.add(grupo.getSelecoes().get(0));
            qualificados.add(grupo.getSelecoes().get(1));
            terceirosColocados.add(grupo.getSelecoes().get(2));
        }

        terceirosColocados.sort(Comparator.comparingInt(this::calcularPontos).reversed());
        qualificados.addAll(terceirosColocados.subList(0, 4));

        realizarSorteio(qualificados);
    }

    private void realizarSorteio(List<Pais> equipes) {
        Collections.shuffle(equipes);
        List<Jogo> oitavas = new ArrayList<>();
        for (int i = 0; i < equipes.size() / 2; i++) {
            oitavas.add(new Jogo(i + 1, null, equipes.get(i), equipes.get(equipes.size() - 1 - i), "Data", "Estádio"));
        }
        realizarMataMata(oitavas);
    }

    public void realizarMataMata(List<Jogo> jogos) {
        List<Jogo> proximosJogos = new ArrayList<>(jogos);
        while (proximosJogos.size() > 1) {
            List<Jogo> vencedores = new ArrayList<>();
            for (Jogo jogo : proximosJogos) {
                Pais vencedor = realizarJogo(jogo);
                if (vencedores.size() % 2 == 0) {
                    vencedores.add(new Jogo(vencedores.size() + 1, null, vencedor, null, "Data", "Estádio", 0, 0));
                } else {
                    vencedores.get(vencedores.size() - 1).setTimeVisitante(vencedor);
                }
            }
            proximosJogos = vencedores;
        }
        Pais campeao = proximosJogos.get(0).getTimeCasa();
        System.out.println("O campeão é: " + campeao.getNome());
    }

    private Pais realizarJogo(Jogo jogo) {
        // Simular um jogo e determinar o vencedor
        Random random = new Random();
        int golsCasa = random.nextInt(5);
        int golsVisitante = random.nextInt(5);
        jogo.setGolsCasa(golsCasa);
        jogo.setGolsVisitante(golsVisitante);
    
        System.out.println("Jogo: " + jogo.getTimeCasa().getNome() + " " + golsCasa + " x " + golsVisitante + " " + jogo.getTimeVisitante().getNome());
    
        if (golsCasa > golsVisitante) {
            return jogo.getTimeCasa();
        } else if (golsVisitante > golsCasa) {
            return jogo.getTimeVisitante();
        } else {
            // Critério de desempate (pênaltis, sorteio, etc.)
            return random.nextBoolean() ? jogo.getTimeCasa() : jogo.getTimeVisitante();
        }
    }

    public void realizarJogosFaseDeGrupos() {
        for (Grupo grupo : grupos) {
            List<Pais> selecoes = grupo.getSelecoes();
            List<Jogo> jogosRealizados = new ArrayList<>();

            for (int i = 0; i < selecoes.size(); i++) {
                for (int j = i + 1; j < selecoes.size(); j++) {
                    Pais casa = selecoes.get(i);
                    Pais visitante = selecoes.get(j);
                    
                    // Verifica se o jogo já foi realizado para não repetir o confronto
                    boolean jogoJaRealizado = false;
                    for (Jogo jogo : jogosRealizados) {
                        if ((jogo.getTimeCasa() == casa && jogo.getTimeVisitante() == visitante) ||
                            (jogo.getTimeCasa() == visitante && jogo.getTimeVisitante() == casa)) {
                            jogoJaRealizado = true;
                            break;
                        }
                    }

                    if (!jogoJaRealizado) {
                        // Cria um jogo entre as duas seleções
                        Jogo jogo = simularJogo(grupo, casa, visitante);
                        jogosRealizados.add(jogo);

                        // Registra o jogo para ambas as seleções
                        casa.adicionarJogo(jogo);
                        visitante.adicionarJogo(jogo);
                    }
                }
            }

            // Adiciona os jogos realizados ao DAO de Jogo
            for (Jogo jogo : jogosRealizados) {
                try {
                    jogoDAO.adicionarJogo(jogo);
                } catch (SQLException e) {
                    System.out.println("Erro ao adicionar jogo: " + e.getMessage());
                }
            }
        }
    }

    public int calcularPontos(Pais pais) {
        int pontos = 0;
        
        // Percorre todos os grupos para verificar os jogos disputados pelo país
        for (Grupo grupo : grupos) {
            for (Pais selecao : grupo.getSelecoes()) {
                if (selecao.getId() == pais.getId()) {
                    // Encontra os jogos onde o país participou
                    for (Jogo jogo : selecao.getJogos()) {
                        if (jogo.getGolsCasa() >= 0 && jogo.getGolsVisitante() >= 0) { // Verifica se o jogo já foi realizado
                            // Calcula pontos com base no resultado do jogo
                            if (pais.equals(jogo.getTimeCasa())) {
                                if (jogo.getGolsCasa() > jogo.getGolsVisitante()) {
                                    pontos += 3; // Vitória
                                } else if (jogo.getGolsCasa() == jogo.getGolsVisitante()) {
                                    pontos += 1; // Empate
                                }
                            } else if (pais.equals(jogo.getTimeVisitante())) {
                                if (jogo.getGolsVisitante() > jogo.getGolsCasa()) {
                                    pontos += 3; // Vitória
                                } else if (jogo.getGolsCasa() == jogo.getGolsVisitante()) {
                                    pontos += 1; // Empate
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return pontos;
    }   
    
    public Optional<Jogador> obterDadosIndividuaisJogador(int jogadorId) throws SQLException {
        return jogadorDAO.obterJogadorPorId(jogadorId);
    }

    public Optional<Pais> obterDadosEquipe(int paisId) throws SQLException {
        return paisDAO.obterPaisPorId(paisId);
    }

    public List<Jogador> obterJogadoresPorEquipe(int paisId) throws SQLException {
        return jogadorDAO.obterJogadoresPorPais(paisId);
    }

    public List<Jogador> obterMelhoresMarcadores() throws SQLException {
        return jogadorDAO.obterMelhoresMarcadores();
    }

    public void iniciarCampeonato() {
        criarGrupos();
        realizarJogosFaseDeGrupos();
        classificarEquipes();
    }

    // Métodos adicionais para gerenciar jogadores, jogos, etc.
}