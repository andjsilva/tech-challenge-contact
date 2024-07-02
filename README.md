# Arquitetura de Sistemas .Net com Azure

## Projeto destinado aos tech challenges da pós tech FIAP

Cada Tech Challenge é uma solução a parte com sua própria documentação.

## Branchs
- master: branch produtiva
- develop: branch de desenvolvimento

## Padrão de commits
**tipo(titulo):descrição**

o título é opcional.

### Tipos
- chore: alteração na documentação
- fix: correções de bugs
- feature: novas funcionalidades

## Banco de dados
### Padrão de nomenclaturas

- Nomes das tabelas no singular
- Nomes das colunas no singular
- Nomes em inglês
- Pascal casing (ex: UserRole)
- O id de cada tabela deve ser o nome da tabela seguido de Id (ex: UserRoleId)
- Para fazer a migração executar o comando Add-Migration NomeDaMigracao -OutputDir Infrastructure/Migrations ( NomeDaMigracao seguir o padrão AddTbl_Descrição, DelTbl_Descrição, AddFields_Descrição ....)
- A migração é executada automaticamente não é necessário executar o comando Update-Database.


## Classes Diagrams

```mermaid
---
title: Contact Class Diagram
---
classDiagram
Contact --> "many" Email : Contains
Contact --> "many" PhoneNumber : Contains
Email --* EmailAddressType : Composition
PhoneNumber --* PhoneNumberType : Composition
    class Contact{
        Guid ContactId
        string Name
    }
    class Email{
        EmailAddressType
        string Address
        Guid ContactId
    }
    class EmailAddressType{
        Personal = 1
        Commercial = 2
    }
    class PhoneNumber{
        PhoneNumberType
        string CountryCode
        string AreaCode
        string Number
        Guid ContactId
    }
    class PhoneNumberType{
        Cellular = 1,
        Commercial = 2,
        Home = 3
    }
```


## Request flow

```mermaid
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    User <-->|Request|ContactController
    ContactController <-->ContactAppService
    ContactAppService <-->ContactDomainDomainService
    ContactDomainDomainService <-->|Validate|Contact
    Contact <--> id2{This is the text in the box}
    id2{Is Valid?} <--> |Yes|ContactRepository
    id2{Is Valid?} <--> |No|ContactDomainDomainService
    ContactRepository <-->id1[(Database)]

```
