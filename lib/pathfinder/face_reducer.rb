class Pathfinder
  class FaceReducer
    class Face
      def initialize face_vertices
        @vertices = face_vertices
      end

      def furthest_vertex_pair
        @vertices.combination(2)
          .map { |a,b| [ a.distance(b), [a,b] ] }
          .sort { |a,b| a.first <=> b.first }
          .last
          .last
      end

      def to_s
        @vertices.map { |v| v.to_s }.join(" ")
      end
    end

    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
      @modified = false
    end

    def reduce
      puts "REDUCE!"
      @modified = false

      face = find_a_face
      furthest_pair = face.furthest_vertex_pair
      puts "Face is: #{face}"
      puts furthest_pair.map { |v| v.to_s }.join(' ')
      @modified
    end

    private

    def find_a_face
      graph.vertices.each do |start_vertex|
        face = traverse_face start_vertex
        return Face.new(face) if face
      end
    end

    def traverse_face(start_v, current_v = start_v, accum = [])
      return false if accum.length > 4
      return accum if current_v == start_v and accum.length > 0

      successors = Array(graph.successors current_v)
      (successors - [accum.last]).each do |next_v|
        face = traverse_face(start_v, next_v, accum + [current_v])
        return face if face
      end

      return false
    end
  end
end