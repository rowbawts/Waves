extends Node

# Constants
var SAMPLE_RATE = 44100  # Adjust as needed
var DURATION = 5.0      # Duration of the wave in seconds
var AMPLITUDE = 0.5     # Amplitude of the wave
var FREQUENCY = 440.0   # Frequency in Hz

func _ready():
	# Calculate the number of samples
	var num_samples = int(SAMPLE_RATE * DURATION)
	
	# Generate the wave data using FFT
	var wave_data = generate_sine_wave(num_samples, AMPLITUDE, FREQUENCY)
	
	# Create a VisualInstance (for visualization purposes)
	var visual_instance = VisualInstance3D.new()
	var mesh = Mesh.new()
	
	# Create a SurfaceTool to manipulate the mesh
	var st = SurfaceTool.new()
	
	# Create vertices and triangles for the 3D grid
	for i in range(num_samples):
		var t = i / float(SAMPLE_RATE)
		var sample = wave_data[i]
		st.add_vertex(Vector3(t, sample, 3.0))  # Adjust the third dimension as needed
		
		# Connect vertices to form triangles
		if i > 0:
			st.add_index(i - 1)
			st.add_index(i)
	
	# Create the surface and set the mesh
	st.create_to(mesh)
	visual_instance.set_surface_material(0, ShaderMaterial.new())
	visual_instance.mesh_instance_set_mesh(0, mesh)
	
	# Add the VisualInstance as a child to visualize the wave
	add_child(visual_instance)

func generate_sine_wave(num_samples, amplitude, frequency):
	var wave_data = []
	for i in range(num_samples):
		var t = i / float(SAMPLE_RATE)
		var sample = amplitude * sin(2.0 * PI * frequency * t)
		wave_data.append(sample)
	return wave_data
