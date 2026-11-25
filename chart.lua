local chart = {
    bpm = 130,
    ofsset = 0,
}

local pattern = {
    { 0, 1 }, { 1, 2 }, { 2, 3 }, { 3, 4 },
    { 4, 4 }, { 5, 3 }, { 6, 2 }, { 7, 1 },
    { 8, 1 }, {8.2, 2}, { 9, 3 }, {10, 4 },
    {11, 2 }, {11.5,3}, {12, 1 }, {12, 4 },
    {14, 2 }, {14, 4 },
    {16, 1 }, {16.5,1}, { 17, 2}, {18, 4 }, {18.5,4}, {19, 4},
    {20, 1 }, {21, 3 }, { 22, 2}, {23, 4 },
    {20, 1 }, {24, 4 },
}

function chart.createNotes()
    local secondPerBeat = 60 / chart.bpm
    local notes = {}
    for _, item in ipairs(pattern) do
        table.insert(notes, {time = chart.ofsset + item[1] * secondPerBeat, lane = item[2], done = false})
    end

    table.sort(notes, function(a, b) return a.time < b.time end)

    return notes
end

return chart
