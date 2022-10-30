local vector = function (x, y ,z)
    return (function ()
        local vector_table = {}
        vector_table.__index = vector_table
        
        function vector_table:set(x, y, z)

            if not z then
                z = 0
            end

            self.x = x
            self.y = y
            self.z = z

        end

        function vector_table:unpack()
            return self.x, self.y, self.z
        end

        function vector_table:to_screen()
            local vector_to_screen = renderer.get_world_to_screen(self.x, self.y, self.z)
            return {
                x = vector_to_screen.x,
                y = vector_to_screen.y,
            }
        end

        function vector_table.new(x, y, z)

            if not z then
                z = 0
            end

            setmetatable({
                x = x,
                y = y,
                z = z,
            }, vector_table)

        end

        return vector_table
        
    end)().new(x, y ,z)
end
