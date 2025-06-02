# 💰 Guarda Grana - Gestor de Gastos (Frontend)

Frontend do projeto desenvolvido como parte da disciplina **SSC0961 - Desenvolvimento Web e Mobile**, utilizando **Flutter** para criar uma aplicação multiplataforma focada em gestão de finanças pessoais.

---

## 🏠 Introdução

**Guarda Grana** é uma aplicação Flutter desenvolvida com o objetivo de ajudar pessoas a organizarem sua vida financeira de forma simples e acessível. A proposta é atender diferentes perfis de usuários, desde estudantes até aposentados, oferecendo funcionalidades como controle de receitas e despesas, definição de metas e alertas financeiros.

---

## ✨ Funcionalidades Principais

- ✅ Registro de receitas e despesas com categorias
- ✅ Controle de contas a pagar (com notificação)
- ✅ Definição e acompanhamento de metas financeiras
- ✅ Relatórios e dashboards com gráficos interativos
- ✅ Interface responsiva e acessível

---

## 🧑‍💼 Personas

Foram mapeadas 8 personas principais, como:

- Pessoa iniciante em finanças
- Autônomos com renda variável
- Estudantes com orçamento limitado
- Pessoas com dívidas e metas de quitação

Cada persona guiou o design de funcionalidades específicas da interface.

---

## 🎨 Protótipo

- 📱 [Interação no Figma](https://www.figma.com/proto/9YEdAsceRUaD8SQKBMJpNq/Gestor-de-Gastos---GuardaGrana?node-id=132-4814&p=f&t=XcgdmcLyVqwkgF0I-0&scaling=scale-down&content-scaling=fixed&page-id=102%3A15&starting-point-node-id=132%3A4814)
- 🖼️ [Visualização das telas](https://www.figma.com/design/9YEdAsceRUaD8SQKBMJpNq/Gestor-de-Gastos---GuardaGrana?node-id=102-15&t=J7LkDu9cGL4qr7OE-1)

---

## 🧰 Tecnologias Utilizadas

- **Flutter** (Dart)
- **Figma** (UI/UX)
- **API RESTful** (Backend separado) (link aqui)
- Compatível com **Android**, **iOS**, **Web** e **Desktop**

---

## ▶️ Como Rodar o Projeto

### 1. Pré-requisitos

- [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile#199-tab-panel)
- [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- Dispositivo físico ou emulador Android/iOS

### 2. Clonar o projeto

```bash
git clone https://github.com/seu-usuario/guarda-grana-frontend.git
cd guarda-grana-frontend

### 3. Instalar dependências

```bash
flutter pub get

### 4. Rodar o projeto 

```bash
flutter run -d chrome --web-port=8000

Você pode escolher o emulador ou dispositivo ao iniciar.

## 🌐 Integração com o Backend

A aplicação consome uma API RESTful (em desenvolvimento separado). Certifique-se de que o backend esteja rodando em:

```bash
http://localhost:8080/api/

Configure a baseURL da API no arquivo responsável pelas requisições (ex: api_service.dart).