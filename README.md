# PaLevá - Sistema de Gestão de Restaurante

## Descrição
- Boas-vindas ao PaLevá, um projeto feito em Ruby on Rails.
- O projeto permite que o usuário crie e gerencie seu restaurante;
Este é um sistema de gestão de restaurante desenvolvido em Ruby on Rails. O projeto permite que os usuários cadastrem restaurantes, itens (pratos e bebidas), e gerenciem pedidos. A aplicação também conta com funcionalidades de autenticação, controle de acesso e gerenciamento de dados de horários de funcionamento.

## Funcionalidades
- <p> <strong>Cadastro de usuários e autenticação</strong>: Utiliza o Devise para autenticação e registro de usuários.</p>
- <p> <strong>Gestão de restaurantes</strong>: Um usuário pode cadastrar um restaurante e gerenciar seus dados.</p>
- <p> <strong>Horários de funcionamento</strong>: Antes da realização de pedidos, é necessário definir o horário de funcionamento do restaurante, para que pedidos não sejam feitos enquanto o restaurante estiver fechado.</p>
- <p> <strong>Cargos</strong>: O dono do restaurante pode cadastrar cargos para os funcionarios de seu restaurante. O cargo é um dado necessário na criação de pré-registros.</p>
- <p> <strong>Pré-cadastro</strong>: O dono do restaurante pode realizar pré-cadastros, informando o CPF,  E-mail e o Cargo de seus funcionários. Ao criar uma conta que bata com esses dados, o usuário será criado como Employee, e terá acesso somente ao restaurante, seu perfil e à página de pedidos</p>
- <p> <strong>Itens</strong>: O sistema permite que o restaurante cadastre pratos e bebidas.</p>
- <p> <strong>Cardápios</strong>: O usuário pode cadastrar cardápios para seu restaurante, e inserir itens ao mesmo. O cardápio pode ser regular ou sazonal (com data para início e fim).</p>
- <p> <strong>Pedidos</strong>: Permite a criação de pedidos para os itens do cardápio.</p>
- <p> <strong>Descontos</strong>: O dono do restaurante pode criar descontos. Cada desconto deve conter data de início e fim, e pode conter um número máximo de uso. Só serão válidos os descontos que estivem dentro da validade e/ou possuírem mais de 0 usos restantes. É possível associar porções à descontos. Essas porções terão seus preços alterados e, caso sejam incluídas em um pedido, o mesmo será exibido na tela de detalhe do desconto usado.</p>

## Tecnologias Utilizadas
- **Linguagem**: Ruby 3.3.5 
- **Framework**: Rails 7.2.1.1
- **Estilização**: Tailwind
- **Banco de dados**: SQLite3
- **Autentição**: Devise
- **Para adicionar imagens aos itens**: ActiveStorage
- **Testes**: RSpec / Capybara

## Como Rodar o Projeto

### 1. Clonar o repositório

Clone o repositório para sua máquina local:

```bash
git clone https://github.com/PedroD98/PaLeva.git
cd paleva
```

### 2. Baixar e instalar as gems utilizadas no projeto

Execute o comando no terminal parar instalar as gems:

```bash
bundle install
```

### 2. Rode as migrations

Para rodar as migrations pendentes, execute:

```bash
rails db:migrate
```

## Acessando o projeto no navegador

### Populando o projeto

Com o setup do projeto feito, você pode executar e acessar o projeto em seu navegador 
```bash
bin/dev
```
### Utilizando Seeds 🌱

Caso não queria preencher todos os dados do zero, o arquivo seeds.rb foi populado com tudo que você precisa para observar as funcionalidades da aplicação

Execute o comando no terminal para popular seu banco de dados
```bash
rails db:seed
```

## Link para cliente buscar o pedido

### O cliente pode acessar o status do seu pedido através do link

```bash
localhost:3000/search_orders
```
