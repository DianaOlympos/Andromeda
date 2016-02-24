# Andromeda

This is a fleet commander helper for Eve Online.
Based on websocket for real time.
Launch a fleet as a fleet commander, then give the link to your players.

###TODO List

- [x] Implement SSO
- [x] Implement a registry for user : ETS+Agent
- [x] Implement Authentication
- [x] Implement Channels
- [ ] Implement protocol to talk
- [ ] Implement fitting endpoint
- [ ] Implement location endpoint
- [ ] Implement map API
- [x] Implement map from SDE
- [ ] Implement fleets

###Feature List

- [x] Map data
- [ ] Implement matrix of 5 jumps
- [ ] Implement A* for destination
- [ ] Implement FC
- [ ] Implement catch-up

### to use :
- You can use the exrm (not finished) pack (instructions to come)

- Or you can use this website : not here yet

- Or you can pull the repo in a folder named "andromeda"
If you have elixir 1.2+ (need erlang 18+) then you can cd into the andromeda/ folder and
```mix phoenix.server``` should compile and run the server. If he yell for dependencies, run
```mix deps.get``` before phoenix.server
