# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", character: movies.first)

puts "Seeding database..."

# Users
puts "Creating users..."
User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "password123"
end

User.find_or_create_by!(email_address: "test@example.com") do |u|
  u.password = "password123"
end

# Countries
puts "Creating countries..."
Country.find_or_create_by!(name: "Brazil", status: "public")
Country.find_or_create_by!(name: "United States", status: "public")
Country.find_or_create_by!(name: "Portugal", status: "public")
Country.find_or_create_by!(name: "Spain", status: "public")

# Medications
puts "Creating medications..."
medications = [
  { name: "Prednisone", description: "Corticosteroid", dosage: "10mg", unit: "mg" },
  { name: "Carprofen", description: "NSAID for dogs", dosage: "75mg", unit: "mg" },
  { name: "Amoxicillin", description: "Antibiotic", dosage: "250mg", unit: "mg" }
]
medications.each do |med|
  Medication.find_or_create_by!(name: med[:name], description: med[:description], dosage: med[:dosage], unit: med[:unit])
end

# Products
puts "Creating products..."
products = [
  { name: "Arroz Integral", brand: "Cará", kind: "Alimentício" },
  { name: "Feijão Carijó", brand: "Cará", kind: "Alimentício" },
  { name: "Leite Desnatado", brand: "Parmalat", kind: "Laticínio" },
  { name: "Pão Integral", brand: "Wickbold", kind: "Padaria" },
  { name: "Macarrão", brand: "Barilla", kind: "Massas" },
  { name: "Azeite", brand: "Andorinha", kind: "Óleos" },
  { name: "Café", brand: "3 Corações", kind: "Bebidas" },
  { name: "Açúcar", brand: "União", kind: "Açucares" },
  { name: "Sal", brand: "Cisne", kind: "Temperos" },
  { name: "Óleo de Soja", brand: "Liza", kind: "Óleos" },
  { name: "Alho", brand: "Horta", kind: "Verduras" },
  { name: "Cebola", brand: "Horta", kind: "Verduras" },
  { name: "Tomate", brand: "Horta", kind: "Verduras" },
  { name: "Batata", brand: "Horta", kind: "Verduras" },
  { name: "Cenoura", brand: "Horta", kind: "Verduras" },
  { name: "Banana", brand: "Feira", kind: "Frutas" },
  { name: "Maçã", brand: "Feira", kind: "Frutas" },
  { name: "Laranja", brand: "Feira", kind: "Frutas" },
  { name: "Mamão", brand: "Feira", kind: "Frutas" },
  { name: "Abacate", brand: "Feira", kind: "Frutas" }
]
products.each do |prod|
  Product.find_or_create_by!(name: prod[:name], brand: prod[:brand], kind: prod[:kind])
end

# Tags
puts "Creating tags..."
tags = ["importante", "urgente", "lazer", "trabalho", "saúde"]
tags.each do |name|
  Tag.find_or_create_by!(name: name)
end

# People (Family members)
puts "Creating people..."
people = [
  { name: "Nelson", borned_on: "1990-05-15" },
  { name: "Maria", borned_on: "1992-08-20" },
  { name: "João", borned_on: "2018-03-10" },
  { name: "Ana", borned_on: "1985-12-01" },
  { name: "Carlos", borned_on: "1988-04-25" },
  { name: "Sofia", borned_on: "2020-07-14" },
  { name: "Pedro", borned_on: "2015-11-30" },
  { name: "Lucas", borned_on: "2022-02-08" },
  { name: "Juliana", borned_on: "1995-09-18" },
  { name: "Marcelo", borned_on: "1982-06-22" }
]
people.each do |p|
  Person.find_or_create_by!(name: p[:name], borned_on: p[:borned_on])
end

# Dogs (Pets)
puts "Creating dogs..."
dogs = [
  { name: "Buddy", race: "Golden Retriever", birth: "2020-06-01", sex: 0 },
  { name: "Luna", race: "Poodle", birth: "2019-11-15", sex: 1 },
  { name: "Max", race: "Labrador", birth: "2021-03-10", sex: 0 },
  { name: "Bella", race: "Shih Tzu", birth: "2018-08-22", sex: 1 },
  { name: "Thor", race: "Husky Siberiano", birth: "2019-01-05", sex: 0 },
  { name: "Molly", race: "Yorkshire Terrier", birth: "2022-05-12", sex: 1 },
  { name: "Charlie", race: "Beagle", birth: "2020-12-01", sex: 0 },
  { name: "Lucy", race: "Pug", birth: "2017-09-18", sex: 1 }
]
dogs.each do |d|
  Dog.find_or_create_by!(name: d[:name], race: d[:race], birth: d[:birth], sex: d[:sex])
end

# Galleries
puts "Creating galleries..."
galleries = ["Férias 2024", "Natal 2024", "Aniversário 2025"]
galleries.each do |name|
  Gallery.find_or_create_by!(name: name, folder_name: name.parameterize)
end

# Tasks
puts "Creating tasks..."
tasks = [
  { name: "Lavar roupa", is_completed: false },
  { name: "Comprar medicamentos", is_completed: false },
  { name: "Levar cão ao veterinário", is_completed: false },
  { name: "Pagar contas do mês", is_completed: false },
  { name: "Agendar reunião", is_completed: false },
  { name: "Buscar crianças na escola", is_completed: true },
  { name: "Fazer compras do mês", is_completed: false },
  { name: "Limpar casa", is_completed: false },
  { name: "Preparar jantar", is_completed: true },
  { name: "Revisão do carro", is_completed: false },
  { name: "Dentista", is_completed: false },
  { name: "Buscar处方 médica", is_completed: false },
  { name: "Paginar contas", is_completed: true },
  { name: "Organizar escritório", is_completed: false },
  { name: "Comprar presente", is_completed: false },
  { name: "Ligar para família", is_completed: true },
  { name: "Agendamento Academia", is_completed: false },
  { name: "Entrega de dinheiro", is_completed: false },
  { name: "Buscar compras online", is_completed: false },
  { name: "Consulta oftalmologista", is_completed: false }
]
tasks.each do |t|
  Task.find_or_create_by!(name: t[:name], is_completed: t[:is_completed])
end

# Notes
puts "Creating notes..."
notes = [
  { title: "Lembretes", body: "Comprar arroz e feijão\nLevar roupas na lavanderia\nBuscar crianças às 17h" },
  { title: "Ideias", body: "Implementar nova funcionalidade\nMelhorar UX do formulário\nAdicionar tema escuro" },
  { title: "Receitas", body: "Bolo de cenoura\nFrango assado\nStrogonoff" },
  { title: "Lista de Compras", body: "Leite\nPão\nQueijo\nPresunto\nFrutas\nVerduras" },
  { title: "Contatos Importantes", body: "Médico: Dr. João - (11) 99999-0000\nEscola: (11) 3333-0000\nVizinho: (11) 99999-1111" },
  { title: "Aniversários", body: "Maria: 20/08\nJoão: 10/03\nAna: 01/12" },
  { title: "Metas do Ano", body: "Viajar para Europa\nAprender inglês\nComprar casa\nAcademia 3x por semana" },
  { title: "Projetos", body: "Reformar cozinha\nMudar quintal\nPintar garage" },
  { title: "Senhas", body: "WiFi: senha123\nNetflix: user@email\nBanco: ***" },
  { title: "Filmes para Ver", body: "Interestelar\n matrix\nPoderoso Chefão\nClube da Luta" }
]
notes.each do |n|
  Note.find_or_create_by!(title: n[:title], body: n[:body])
end

# Cards
puts "Creating cards..."
cards = [
  { name: "Nubank", brand: "Nubank", number: "1234", expiry_month: 12, expiry_year: 2027, due_day: 5, limit: 10000 },
  { name: "Itaú", brand: "Itaú", number: "5678", expiry_month: 6, expiry_year: 2026, due_day: 10, limit: 5000 }
]
cards.each do |c|
  Card.find_or_create_by!(name: c[:name], number: c[:number], brand: c[:brand], expiry_month: c[:expiry_month], expiry_year: c[:expiry_year], due_day: c[:due_day], limit: c[:limit])
end

# Patients (People & Dogs as patients)
puts "Creating patients..."
Person.all.each do |person|
  Patient.find_or_create_by!(individual: person) unless Patient.exists?(individual: person)
end
Dog.all.each do |dog|
  Patient.find_or_create_by!(individual: dog) unless Patient.exists?(individual: dog)
end

puts "Seeding complete!"
