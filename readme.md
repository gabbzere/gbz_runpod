SamplercustomAdvacnced latent shapes error; 


Navigate to the following file:
ComfyUI/custom_nodes/comfyui_pulid_flux_ll/pulidflux.py


Update the function definition (around line 605) by adding latent_shapes=None and **kwargs to the end of the argument list.
change this
def pulid_outer_sample_wrappers_with_override(wrapper_executor, noise, latent_image, sampler, sigmas, denoise_mask=None, callback=None, disable_pbar=False, seed=None):

to this 
def pulid_outer_sample_wrappers_with_override(wrapper_executor, noise, latent_image, sampler, sigmas, denoise_mask=None, callback=None, disable_pbar=False, seed=None, latent_shapes=None, **kwargs):


A few lines down inside that same function (around line 621), find the line where it calls wrapper_executor(...) and add **kwargs there as well
change this; 
out = wrapper_executor(noise, latent_image, sampler, sigmas, denoise_mask, callback, disable_pbar, seed)

to this
out = wrapper_executor(noise, latent_image, sampler, sigmas, denoise_mask, callback, disable_pbar, seed, **kwargs)
