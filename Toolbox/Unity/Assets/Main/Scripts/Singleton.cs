using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;



public class Singleton : MonoBehaviour
{
    //Singleton design paradigm - no instances of the Manager
    //Will be able to be carried over in other scenes
    public static Singleton myAppManager;

    void Awake()
    {
        _Singleton();
    }

    private void _Singleton()
    {
        if (myAppManager != null)
        {
            //Destroy the gameObject if we already have a Manager
            Destroy(gameObject);
            
        }
        else
        {   //Keep this as our Manager - applies to every scene
            myAppManager = this;
            DontDestroyOnLoad(gameObject);
        }
    }
}
