using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

public class Meshing : MonoBehaviour {

    // Links to the materials of the ground mesh
    public Material Mat_Black;
    public Material Mat_Ground;
    public Material Mat_MeshingOff;

    // visibility state - state whether ground mesh is visible
    private bool _visible = true;

    // Link to the MLSpatialMapper component on this GameObject
    private MLSpatialMapper _mapper;
    private Transform _meshes;
    	
    void Awake() {
        _mapper = GetComponentInChildren<MLSpatialMapper>();
        _meshes = _mapper.meshParent;
    }

    // Update the mesh material
    void Update() {
    	UpdateMeshMaterial();
	}	
    
    // UpdateMeshMaterial()
    // Switch mesh material based on whether meshing is active and mesh is visible
    // visible & active = ground material
    // visible & inactive = meshing off material
    // invisible = black mesh
    void UpdateMeshMaterial() {
       // Loop over all the child mesh nodes created by the MLSpatialMapper script
        for (int i=0;i<_meshes.childCount;i++) {
            // Get the child gameObject
            GameObject gameObject = _meshes.GetChild(i).gameObject;
            // Get the meshRenderer component
            MeshRenderer meshRenderer = gameObject.GetComponentInChildren<MeshRenderer>();
            // Get the assigned material 
		    Material material = meshRenderer.sharedMaterial;
            if (_visible) {
                if (_mapper.enabled) {
			        if (material != Mat_Ground) {
				        meshRenderer.material = Mat_Ground;
			        }
                }
                else if (material != Mat_MeshingOff) {
				    meshRenderer.material = Mat_MeshingOff;
               }
            }
            else if (material != Mat_Black) {
                meshRenderer.material = Mat_Black;
            }
        }
    }
 
    // Toggle the visibility state of the ground mesh
    public void toggleMeshVisibility() {
        _visible = _visible ? false : true;
    }

    // Toggle whether the MLSpatialMapper script is active (mesh updates)
    public void toggleMeshScanning() {
        _mapper.enabled = _mapper.enabled ? false : true;
    }

    // Reset the meshing states 
    public void resetMeshing() {
        // Make mesh visible
        _visible = true;
        // Turn mesh scanning on
        _mapper.enabled = true;
    }

}



