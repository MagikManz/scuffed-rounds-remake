--[[
    This module contains the components used in the game.
    Components are used to store data about entities in the game. They are used to store data that is shared between systems and can be accessed by any system that needs it.

    @module Components
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.matter)

local component = Matter.component

export type Components = { 
    Character: Character,
    Client: Client,
    Renderable: Renderable,
    Transform: Transform,
    
    Gravity: Gravity,
}

local Components: Components = { } :: Components

Components.Character = component("Character", { })
export type Character = typeof(component(nil, { })) & {
    walkspeed: number,
    health: number,
    maxHealth: number,
    regen: number,
    moveDirection: Vector3,
}

Components.Client = component("Client", { })
export type Client = typeof(component(nil, { })) & {
    player: Player,
}

Components.Transform = component("Transform", { })
export type Transform = typeof(component(nil, { })) & {
    moveForce: Vector2,
    downwardForce: Vector2,
}

Components.Renderable = component("Renderable", {})
export type Renderable = typeof(Matter.component(nil, {})) & {
	model: Frame,
}

Components.Gravity = component("Gravity", { })
export type Gravity = typeof(component(nil, { })) & {
    gravityForce: number,
}


return table.freeze(Components) :: Components
