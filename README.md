# daoao - DAO on AO

This is a demo using [AO](https://ao.arweave.dev/) to build DAOs.

## How to use it?

1. Install ao
```sh
npm i -g https://get_ao.g8way.io
```
2. Download this blueprint (daoao.lua)
3. Initialize aos
```sh
aos
```
4. Load the blueprint
```sh
.load daoao.lua
```
5. Start to use it.

### Available options
After you load the blueprint, you can execute the different available actions:

#### Create DAO
```sh
Send({ Target = ao.id, Tags = { Action = "Create", Uid = 'Give a unique Id', Name = 'Give a name', Description = 'Give a description' }})
```
You will receive the message "DAO created".

#### List DAOs
```sh
Send({ Target = ao.id, Tags = { Action = "ListDAO"}})
```
You will get the DAOs encoded in JSON.

#### Get DAO
```sh
Send({ Target = ao.id, Tags = { Action = "GetDAO", UID = 'A unique Id from an existing DAO'}})
```
You will get the selected DAO encoded in JSON.

#### Join DAO
```sh
Send({ Target = ao.id, Tags = { Action = "Join", DAO= 'A unique Id from an existing DAO'}})
```
You will become a member of the selected DAO.

#### Leave DAO
```sh
Send({ Target = ao.id, Tags = { Action = "Leave", DAO= 'A unique Id from an existing DAO'}})
```
You will leave the selected DAO.

#### Get members
```sh
Send({ Target = ao.id, Tags = { Action = "GetMembers", DAO= 'A unique Id from an existing DAO'}})
```
You will get all the current members (and former members) the selected DAO.

#### Add proposal
```sh
Send({ Target = ao.id, Tags = { Action = "AddProposal", DAO= 'A unique Id from an existing DAO', Name = 'A proposal name', Description = 'A proposal description', ProposalId = 'A proposal unique Id'}})
```
You will receive the message "Proposal added."

#### Get proposal
```sh
Send({ Target = ao.id, Tags = { Action = "GetProposal", DAO= 'A unique Id from an existing DAO', ProposalId = 'A unique Id from an existing Proposal in the DAO'}})
```
You will get all the data from the proposal.

#### Vote
```sh
Send({ Target = ao.id, Tags = { Action = "Vote", DAO= 'A unique Id from an existing DAO', ProposalId = 'A unique Id from an existing Proposal in the DAO', Vote = 'Yes or No'}})
```
You will vote for the proposal (you need to be a member of the DAO).

#### Close voting
```sh
Send({ Target = ao.id, Tags = { Action = "CloseVoting", DAO= 'A unique Id from an existing DAO', ProposalId = 'A unique Id from an existing Proposal in the DAO'}})
```
You will close the voting process.
