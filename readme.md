# Mulberry
Mulberry is a cozy fantasy colony-sim for the web.

Mulberry is a "surthrival" game, meaning that there are survival elements; however, the game is not designed to punish the player. Instead Mulberry focuses primarily on cultivating happiness from your villagers. There is no death in mulberry. If a villager's needs are not being met they will become increasingly unhappy, unproductive, and ultimately leave your village. When a villager becomes old or unhappy they may choose to move on.

### Villagers
In mulberry, the villagers' story is everything. Start with a handful of villagers and acquire more as strangers pass through and decide to join your village.
### Fantasy
Villagers are sentient anthropomorphic animals, which means that the use of animal products like milk, eggs, and wool is out of the question. Mulberry includes fantasy alternatives for each of these ingredients. 
### Fishing
While many animals are sentient in mulberry, fish are not included. Fish and bugs are the single source of meat available in mulberry.
### Cooking
Mulberry has dozens of recipes to discover with exotic ingredients and techniques that require exploring the world to obtain. Discover new recipes by experimenting with different techniques and ingredient combinations!
### Brewing
Similar to cooking, Mulberry has dozens of brewing recipes to discover as well as exotic ingredients. Discover new recipes by experimenting with different techniques and ingredient combinations!
### Gardening
Gardening is an important part of mulberry and different plants require different treatment. You can never kill a plant in mulberry, but you can increase or decrease its likelihood to do things like bloom or bear fruit.
### Mining
Mulberry avoids themes of strip mining and environmental exploitation by allowing villagers to collect renewable materials like stones and mine surface minerals that come from falling stars.
### Smithing
Villagers need the right tools for the job and quality tools make for quality work. While tools are not required to do any job in mulberry, they do dramatically improve the quality and output of the work. Smithing tools and infrastructure like copper pipes for irrigation is important.
### Resource Management
Mulberry allows the player to either recycle items altogether or use waste products in a useful ways such as compost or fertilizer.
### Artisans
To know a colony is truly thriving is to know it is capable of sustaining artisans. To be surrounded by beautiful things makes your villagers more happy. Artisans include trades such as painting, sculpting, pottery, and glass-blowing.
### Decor
Decorations in homes and around the village improve villager mood and increase happiness. Artisans will occasionally craft decorative items based on the season.
### Seasons
Mulberry has seasons that primarily change what is available in the environment.
### Environmentally Friendly Infrastructure
Mulberry avoids heavy mechanization and the burning of fossil fuels en masse, instead focusing on clean energy and renewable materials.
### Story-Telling
Mulberry tells stories through the lives of its villagers. Select any villager to view their life story, from big picture events like weddings and deaths, to small picture things like what they ate for breakfast.


# Task Scheduler

At the heart of this game is the villager AI and at the heart of the villager AI is a task scheduling system. Inspired by games like Rimworld, the player has very little direct control over the villagers. Instead the villagers choose tasks based on a player-managed table that controls task priorities as well as active/inactive hours.

Something important to consider is that "big picture" tasks like cooking might actually be composed of many smaller tasks underneath. For example, cooking a meal requires gathering ingredients, which itself is a task that consists of navigating to the location and "picking up" each ingredient, before finally navigating to the appropriate cooking station and preparing the meal. At any point during this process, the villager's path might become obstructed, ingredients might move or expire, crafting stations may become unavailable, or the task may be canceled altogether. This means that the underlying system must be robust enough to fail gracefully in these situations.

The task scheduler system ultimately has two parts. The player should submit tasks to the task queue by interacting with the world (placing blueprints, billing tasks at workstations, painting crops, etc). When a villager becomes idle, they should (at some point) request a task from the task scheduler based on their assigned priorities. The task scheduler should then find a suitable "big picture" task and break it into smaller sub-tasks (possibly a tree or a stack). At that point, some state machine takes over and puppets the villager through each step until the task is completed or otherwise interrupted.

### Task
A task describes a well defined interface that contains *only* serializable data. A task is represented as a node in a tree, where each parent node must wait for their children to complete before advancing. The leaves of this tree are always the smallest atomic unit of work a villager can perform.

### Automata
An "automata" is the term I am giving to the state machine responsible for handling a task node. An automata contains *only* behavior and non-serializable data. There should be a unique automata for every type of task node. When a task has children, the active automata should be pushed onto a stack and the child automata becomes active until the task is completed.

### Queue
The queue is a series of "big picture" tasks managed by the player and the environment. The player indirectly submits tasks to the queue by interacting with the game (placing blueprints, billing recipes at crafting stations, painting orders, etc), and the environment may automatically enqueue tasks such as watering crops  or harvesting them once they are ripe.

The queue is not a strictly FIFO structure, but instead prioritizes tasks based on the order they are submitted. Idle villagers will request a suitable task from the queue based on their own assigned priorities. A "big picture" task should not be popped from the queue until it is completed or cancelled, but it should be flagged as reserved. 

Once a villager receives a root task from the queue, the remainder of the task tree will be populated with child tasks and the appropriate automata will begin processing the tree.

### Priority
The player can establish villager priorities using a simple table like the one below. Before picking a task, a villager should sort tasks based on their assigned priority.

| Villager | Chop | Cook | Fish | Mine | Tailor | ... |
| -------- | ---- | ---- | ---- | ---- | ------ | --- |
| Shamus   | 5️⃣  | ❌    | ❌    | 1️⃣  | 1️⃣    |     |
| Sheryl   | ❌    | 5️⃣  | 5️⃣  | ❌    | 1️⃣    |     |
| Shannon  | ❌    | ❌    | 5️⃣  | 5️⃣  | ❌      |     |
| Shawn    | 1️⃣  | 1️⃣  | 1️⃣  | 1️⃣  | ❌      |     |

### Schedule
The player can establish villager schedules using a simple table like the one below. In the following example, the villagers Shannon and Shawn are nocturnal, so their schedules are arranged for them to work at night and sleep during the day; whereas Shamus and Sheryl or diurnal.

| Villager | 12AM | 1AM | 2AM | 3AM | 4AM | 5AM | 6AM | ... |
| -------- | ---- | --- | --- | --- | --- | --- | --- | --- |
| Shamus   | 🟪   | 🟪  | 🟪  | 🟪  | 🟪  | 🟩  | 🟩  |     |
| Sheryl   | 🟪   | 🟪  | 🟪  | 🟪  | 🟪  | 🟩  | 🟩  |     |
| Shannon  | 🟩   | 🟩  | 🟩  | 🟩  | 🟩  | 🟩  | 🟪  |     |
| Shawn    | 🟩   | 🟩  | 🟩  | 🟩  | 🟩  | 🟩  | 🟪  |     |

🟪 - Sleep
🟩 - Work
