using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour {

    // Links to other GameObjects
    public GameObject game;
    public GameObject catPrefab;
    public GameObject mainCam;

    // Maximum number of cats to spawn
    public int minNum = 10; 
    public int maxNum = 15; 

    // State set when prefabs have been spawned
    public bool _prefabsPopulated = false;

    // Store the "props" GameObject
    private GameObject _propNode;

    // Name of the Props GameObject
    private string propNodeName = "Props";

    // Dimension of the spawn box volume
    private float spawnDim;

    // Link to audio
    private AudioSource source;
    private float overlapRadius = 0.08f;
    private int numCats = 0;
    private int maxNumAttempts = 100;

    void Awake() {
        source = GetComponent<AudioSource>();        
    }

    // Update  - Set transform of the spawner box at a fixed height in front of the Main Camera
    void Update() {
        gameObject.transform.position = mainCam.transform.position + (2.0f * mainCam.transform.forward);
        gameObject.transform.rotation = Quaternion.Euler(0f, mainCam.transform.rotation.eulerAngles.y, 0f);
    }
    // cleanup - destroy spawned cats, reset state
    public void cleanup() {
        if (_propNode) {
            Destroy(_propNode);
        }
        _prefabsPopulated = false;
    }
    
    // Set visibility state of the spawner volume
    public void setSpawnerVisibility(bool state) {
        GetComponentInChildren<MeshRenderer>().enabled = state;
    }

    // Spawn the cat prefabs in the spawner volume
    public void populatePrefabs () {

        // Play audio
        source.Play();

        // Create new GameObject to parent cats under
        _propNode = new GameObject(propNodeName);
        _propNode.transform.SetParent(game.transform);

        spawnDim = gameObject.transform.localScale.x / 2f;
        Vector3 spawnGuidePos = gameObject.transform.position;

        // Always spawn the maximum
        int spawnNum = Random.Range(minNum, maxNum);

        // Create and parent the cat prefab to the PropNode
        GameObject prefabNode = new GameObject(catPrefab.name);
        prefabNode.transform.SetParent(_propNode.transform);

        // Mask used to find objects in the ground layer
        int layerMask = 1 << 9; // Ground Layer = 9
        int catLayerMask = 1 << 8; // cat layer = 8

        numCats = 0;

        // Spawn the cats (make maxNumAttemptsto spawn spawnNum cats)
        for(int i=0;i<maxNumAttempts;i++) {

            // Random position, rotation
            float x = Random.Range(spawnGuidePos.x - spawnDim, spawnGuidePos.x + spawnDim);
            float z = Random.Range(spawnGuidePos.z - spawnDim, spawnGuidePos.z + spawnDim);
            Quaternion rot = Quaternion.Euler(new Vector3(0, Random.Range(0, 360), 0));

            // Raycast origin
            Vector3 origin = new Vector3(x, spawnGuidePos.y + 10, z);

            // Cast a ray down, spawn cat if ray intersects the ground mesh
            RaycastHit hit;
            if (Physics.Raycast(origin, -Vector3.up, out hit, layerMask)) {
                Collider[] hitColliders = Physics.OverlapSphere(hit.point, overlapRadius, catLayerMask);
                 if (hitColliders.Length == 0) {
                    GameObject newObject = (GameObject)Instantiate(catPrefab, hit.point, rot);
                    Debug.Log("Cat: " + i);
                    setRandomCatColor(newObject);
                    newObject.transform.SetParent(prefabNode.transform);
                    numCats++;
                }  
            } 

            // Finish after max num cats are spawned
            if (numCats >= spawnNum) {
                break;
            }           
        }

        // Set the state of the prefabs
        _prefabsPopulated = true;

        setSpawnerVisibility(false);
    }

    // randomize the spawned cat
    void setRandomCatColor(GameObject newObject) {
       float randomHueShift = Random.Range(0.0f, 360.0f);
        //float randomEyeBlink = Random.Range(0.0f, 1.0f);
        float randomTailWave = Random.Range(4f, 9f);

        Debug.Log("randomHueShift: " + randomHueShift);

        for (int i=0;i<newObject.transform.childCount;i++) {
            int matCount = newObject.transform.GetChild(i).GetComponentInChildren<MeshRenderer>().materials.Length;
            for (int j=0;j<matCount;j++){
                
                Material mat = newObject.transform.GetChild(i).GetComponentInChildren<MeshRenderer>().materials[j];

                // randomize the color
                if (mat.HasProperty("_HueShift")) {
                    mat.SetFloat("_HueShift", randomHueShift);
                }

                // randomize the tail wave speed
                if (mat.HasProperty("_TailWaveFactor")) {
                    mat.SetFloat("_TailWaveFactor", randomTailWave);
                }            
            }
        }
    }
}
