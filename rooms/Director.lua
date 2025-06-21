Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.timer = Timer()

    self.difficulty = 1
    self.round_duration = 22
    self.round_timer = 0

    self.difficulty_to_points = {}
    self.dufficulty_to_points[1] = 16

    for i = 2, 2024, 4 do
        self.difficulty_to_points[i] = self.difficulty_to_points[i] + 8
        self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
        self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1] / 1.5)
        self.difficulty_to_points[i+3] = math.floor(self.difficulty_to_points[i+2]* 2)
    end

    self.enmy_to_points = {
        ['Rock'] = 1,
        ['Shooter'] = 2
    }

end