# 🌸 Hello Kitty Tasks

**Hello Kitty Tasks** é um aplicativo de gerenciamento de tarefas gamificado, voltado para jovens e adolescentes que desejam se organizar de maneira leve, divertida e motivacional. O app combina produtividade com elementos de jogo e uma estética kawaii inspirada no universo Hello Kitty.

## 📱 Plataformas

- Flutter (Android, iOS, Web e Windows Desktop)
- Backend: Django + Django REST Framework

---

## 🎯 Visão Geral

> "Transforme sua lista de tarefas em uma aventura!"

Hello Kitty Tasks oferece:

- ✅ Cadastro e login de usuários
- 📝 Criação, edição, visualização e exclusão de tarefas
- 🔔 Notificações (em breve)
- 🎮 Mini-game com recompensas visuais (em planejamento)
- 🧠 IA da personagem para incentivo (em planejamento)

---

## 👥 Público-Alvo

- Idade: 14 a 30 anos
- Pessoas que gostam de organização mas se desmotivam com métodos tradicionais
- Fãs de estética kawaii, Hello Kitty, games casuais
- Pessoas neurodivergentes (TDAH, ansiedade)

---

## 🚀 Funcionalidades

### Gerenciamento de Tarefas
- Prioridades: baixa, média, alta
- Status visual de progresso
- Organização por categorias

### Gamificação (Futuro)
- Mini-game 2D ambientado no quarto da personagem
- Sistema de moedas e recompensas visuais
- Avatar interativo

### IA da Personagem (Futuro)
- Feedback motivacional
- Conversas simples
- Incentivos personalizados

---

## 🔐 Segurança

- ✅ Autenticação JWT (temporariamente desativada para testes)
- ✅ Validação e hash de senhas
- ✅ Proteção contra SQL Injection e XSS
- 🔒 Regras de permissão (parcial)
- 🔒 CSRF (a validar)
- 🔒 HTTPS (parcialmente configurado)

---

## 🧱 Arquitetura

### Backend

- Django + DRF
- Banco de dados: SQLite (desenvolvimento) / MySQL (produção)
- Padrão: RESTful API
- Endpoints:
  - `/api/register`
  - `/api/login`
  - `/api/tasks`
  - `/api/tasks/<id>`

### Frontend

- Flutter (Dart)
- Padrão MVC simplificado
- Integração via HTTP Package
- Estado local com `setState` (futuro: Provider ou Riverpod)

---

## 🧪 Testes

- Testes manuais de funcionalidades
- Logs básicos implementados
- Testes automatizados em desenvolvimento
- Testes de usabilidade planejados

---

## 📦 Deploy

- Backend: Railway / Render
- Frontend: Compilação Web e Windows Desktop (em uso)
- Mobile: Play Store (futuro)
- Landing Page: Vercel / Netlify (em breve)

---

## 🛠 Equipe

- **Victor Luis Goedicke** – Fullstack & Segurança
- **Eberton Hilário da Rosa Junior** – Backend & API
- **Carlos Kenzo** – Frontend & UX/UI

---

## 📌 Diferenciais do Produto

- 🌈 Estética kawaii imersiva
- 🎮 Mini-game integrado à produtividade
- 🤖 IA que cria vínculo emocional com o usuário
- 🧠 Pensado para neurodivergentes
- ✨ Mistura eficaz de utilidade e entretenimento

---

## 📄 Documentação

- [x] Modelagem do Banco de Dados
- [x] API (Serializers, Views, Endpoints)
- [x] Manual para o usuário (em desenvolvimento)
- [x] Guia de instalação e execução (em breve)

---

## 📷 Imagens e Prévia (em breve)

---

## 📥 Como Contribuir

```bash
# clone o projeto
git clone https://github.com/seu-usuario/hello-kitty-tasks.git

# entre no diretório
cd hello-kitty-tasks

# instale dependências (Flutter)
flutter pub get


💬 Licença
Este projeto está em fase educacional/teste. Licenciamento e uso comercial sob análise.

