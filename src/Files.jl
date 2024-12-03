"""
    function readnodesfile(filepath::String; comment::Char='#', delim::Char=',') -> Dict{Int64, MyGraphNodeModel}

The function reads a file containing edge list information and returns a dictionary of node models.

### Arguments
- `filepath::String`: the path to the file containing the edge list information.
- `comment::Char`: the character that indicates a comment line in the file.
- `delim::Char`: the character that separates the fields in the file.

### Returns
- a dictionary of edge models. The key is the edge id, and the value is a `MyGraphEdgeModel` instance.
"""
function readedgesfile(filepath::String; comment::Char='#', 
    delim::Char=',')::Dict{Int64, MyGraphEdgeModel}

    # initialize
    edges = Dict{Int64,MyGraphEdgeModel}()
    linecounter = 0;
    
    # main -
    open(filepath, "r") do file # open a stream to the file
        for line ∈ eachline(file) # process each line in a file, one at a time
            
            # check: do we have comments?
            if (contains(line, comment) == true) || (isempty(line) == true)
                continue; # skip this line, and move to the next one
            end
            
            # split the line around the delimiter -
            parts = split(line, delim) .|> String
            if (length(parts) != 3)
                push!(parts, "1.0"); # add a default weight, if we need to
            end

            # build the edge model -
            edges[linecounter] = _build(MyGraphEdgeModel, parts, linecounter);

            # update the line counter -
            linecounter += 1;
        end
    end

    # return -
    return edges;
end


"""
    function readnodecapacityfile(filepath::String; comment::Char='#', delim::Char=',') -> Dict{Int64, Tuple{Int64, Int64}}

The function reads a file containing node capacity information and returns a dictionary of node capacities.

### Arguments
- `filepath::String`: the path to the file containing the node capacity information.
- `comment::Char`: the character that indicates a comment line in the file.
- `delim::Char`: the character that separates the fields in the file.

### Returns
- a dictionary of node capacities. The key is the node id, and the value is a tuple of the maximum in-degree and out-degree of a node.
"""
function readnodecapacityfile(filepath::String; comment::Char='#', 
    delim::Char=',')::Dict{Int64, Tuple{Int64, Int64}}

    # initialize
    capacities = Dict{Int64,Tuple{Int64,Int64}}()
    
    # TODO: implement this function
    function readnodecapacityfile(filepath::String; comment::Char='#', delim::Char=',')::Dict{Int64, Tuple{Int64, Int64}}
        # Initialize an empty dictionary to store node capacities
        node_capacities = Dict{Int64, Tuple{Int64, Int64}}()
    
        # Check if file exists
        if !isfile(filepath)
            throw(ArgumentError("File not found: $filepath"))
        end
    
        # Open and read the file
        try
            open(filepath, "r") do file
                for line in eachline(file)
                    # Trim whitespace
                    line = strip(line)
    
                    # Skip empty lines and comments
                    if isempty(line) || startswith(line, comment)
                        continue
                    end
    
                    # Split the line
                    parts = split(line, delim)
    
                    # Validate the line has correct number of parts
                    if length(parts) != 3
                        throw(ArgumentError("Invalid line format: $line"))
                    end
    
                    # Parse node ID and capacities
                    try
                        node_id = parse(Int64, parts[1])
                        in_degree_capacity = parse(Int64, parts[2])
                        out_degree_capacity = parse(Int64, parts[3])
    
                        # Store in the dictionary
                        node_capacities[node_id] = (in_degree_capacity, out_degree_capacity)
                    catch e
                        throw(ArgumentError("Error parsing line: $line. $(e.msg)"))
                    end
                end
            end
        catch e
            throw(ArgumentError("Error reading file: $(e.msg)"))
        end
    
        # Validate that we have capacities
        if isempty(node_capacities)
            throw(ArgumentError("No node capacities found in the file"))
        end
    
        return node_capacities
    end
    

    # return -
    return capacities;
end