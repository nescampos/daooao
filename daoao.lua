local ao = require('ao')
local json = require('json')

DAOs = DAOs or {}
Members = Members or {}
Proposals = Proposals or {}

Handlers.add(
  "create",
  Handlers.utils.hasMatchingTag("Action", "Create"),
  function (msg)
    local uid = msg.Tags.Uid
    local name = msg.Tags.Name
    local description = msg.Tags.Description
    local administrator = msg.From
    DAOs[uid] = {UID = uid, Name = name, Description = description, Administrator = administrator}
    Handlers.utils.reply("DAO created")(msg)
  end
)


Handlers.add(
  "listDAO",
  Handlers.utils.hasMatchingTag("Action", "ListDAO"),
  function (msg)
    ao.send({ Target = msg.From, Tags = { List = json.encode(DAOs)} })
  end
)

Handlers.add(
  "getDAO",
  Handlers.utils.hasMatchingTag("Action", "GetDAO"),
  function (msg)
    ao.send({ Target = msg.From, Tags = { DAO = json.encode(DAOs[msg.Tags.UID])} })
  end
)

Handlers.add(
  "join",
  Handlers.utils.hasMatchingTag("Action", "Join"),
  function (msg)
    local dao = DAOs[msg.Tags.DAO] or {}
    assert(dao ~= {}, "The DAO doesn't exist")
    Members[msg.Tags.DAO] = Members[msg.Tags.DAO] or {}
    Members[msg.Tags.DAO][msg.From] = true
    Handlers.utils.reply("joined")(msg)
  end
)

Handlers.add(
  "leave",
  Handlers.utils.hasMatchingTag("Action", "Leave"),
  function (msg)
    local dao = DAOs[msg.Tags.DAO] or {}
    assert(dao ~= {}, "The DAO doesn't exist")
    Members[msg.Tags.DAO] = Members[msg.Tags.DAO] or {}
    Members[msg.Tags.DAO][msg.From] = false
    Handlers.utils.reply("left")(msg)
  end
)

Handlers.add(
  "getMembers",
  Handlers.utils.hasMatchingTag("Action", "GetMembers"),
  function (msg)
    local dao = DAOs[msg.Tags.DAO] or {}
    assert(dao ~= {}, "The DAO doesn't exist")
    ao.send({ Target = msg.From, Tags = { Members = json.encode(Members[msg.Tags.DAO])} })
  end
)

Handlers.add(
  "addProposal",
  Handlers.utils.hasMatchingTag("Action", "AddProposal"),
  function (msg)
    local dao = DAOs[msg.Tags.DAO] or {}
    assert(dao.Administrator == msg.From, 'The DAO administrator is the only one who can create proposals.')
    local uidDAO = msg.Tags.DAO
    local name = msg.Tags.Name
    local description = msg.Tags.Description
    local owner = msg.From
    local proposalId = msg.Tags.ProposalId
    Proposals[uidDAO] = Proposals[uidDAO] or {}
    Proposals[uidDAO][proposalId] = Proposals[uidDAO][proposalId] or {}
    Proposals[uidDAO][proposalId] = {Name = name, Description = description, Owner = owner, ProposalId = proposalId, No = 0, Yes = 0, opened = true}
    Handlers.utils.reply("Proposal added.")(msg)
  end
)

Handlers.add(
  "getProposal",
  Handlers.utils.hasMatchingTag("Action", "GetProposal"),
  function (msg)
    ao.send({ Target = msg.From, Tags = { Members = json.encode(Proposals[msg.Tags.DAO][msg.Tags.ProposalId])} })
  end
)

Handlers.add(
  "vote",
  Handlers.utils.hasMatchingTag("Action", "Vote"),
  function (msg)
    local member = Members[msg.Tags.DAO][msg.From]
    assert(member == true, "You need to become a member to vote.")
    local uidDAO = msg.Tags.DAO
    local proposalId = msg.Tags.ProposalId
    Proposals[uidDAO] = Proposals[uidDAO] or {}
    Proposals[uidDAO][proposalId] = Proposals[uidDAO][proposalId] or {}
    local vote = msg.Tags.Vote
    if Proposals[uidDAO][proposalId].opened == true then
        if vote == 'Yes' then
            Proposals[uidDAO][proposalId].Yes = Proposals[uidDAO][proposalId].Yes + 1
        else
            Proposals[uidDAO][proposalId].No = Proposals[uidDAO][proposalId].No + 1
        end
        Handlers.utils.reply("Voted sent.")(msg)
    else
        Handlers.utils.reply("Voting process is closed.")(msg)
    end
    
  end
)


Handlers.add(
  "closeVoting",
  Handlers.utils.hasMatchingTag("Action", "CloseVoting"),
  function (msg)
    local dao = DAOs[msg.Tags.DAO] or {}
    assert(dao.Administrator == msg.From, 'The DAO administrator is the only one who can close votings.')
    local uidDAO = msg.Tags.DAO
    local proposalId = msg.Tags.ProposalId
    Proposals[uidDAO] = Proposals[uidDAO] or {}
    Proposals[uidDAO][proposalId] = Proposals[uidDAO][proposalId] or {}
    Proposals[uidDAO][proposalId].opened = false
    Handlers.utils.reply("Voting closed.")(msg)
  end
)