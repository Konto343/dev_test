local module = {}
module.__index = module

--services
local data = game:GetService('DataStoreService')
local template = require(script.Parent.template)

type self = {
	db : DataStore,
    data : {[number] : template.type}
}
export type type = typeof(setmetatable({} :: self, module))

function module.new(db_name : string) : type
    local self = setmetatable({} :: self, module)
    self.db = data:GetDataStore(db_name)
    self.data = {}

    return self
end

function module.load(self : self, user_id : number) : ()
    if not self.data[user_id] then --if no cache
        local data, _key = self.db:GetAsync(
            tostring(user_id)
        )
        self.data[user_id] = data or template.template --set data or new
    end
    return self.data[user_id]
end

function module.save(self : self, user_id : number) : ()
    self.db:SetAsync(
        tostring(user_id), 
        self.data[user_id]
    )
end

function module.purge(self : self, user_id : number) : ()
    self.data[user_id] = nil --clear cache
    self.db:RemoveAsync(
        tostring(user_id)
    )
end

function module.exit(self : self, user_id : number) : ()
    self.db:SetAsync(
        tostring(user_id),
        self.data[user_id]
    )
    self.data[user_id] = nil --clear cache
end

return module