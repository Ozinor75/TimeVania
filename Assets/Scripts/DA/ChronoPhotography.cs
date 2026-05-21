using System;
using System.Collections.Generic;
using NUnit.Framework.Internal;
using UnityEngine;
using UnityEngine.Serialization;

public class ChronoPhotography : MonoBehaviour
{
    
    private GlobalTime manager;
    public float t;
    private int colorIndex;
    public float catchRate;
    public float albumSize;
    public Material photoMaterial;
    public List<Color> colors = new List<Color>(3);
    
    // public List<GameObject> subjects;
    public GameObject subject;
    // private List<List<GameObject>> listOfShoots = new List<List<GameObject>>();
    public List<GameObject> listOfShoots = new List<GameObject>();
    // private Transform parent;
    
    private void Start()
    {
        t = 0;
        manager = FindFirstObjectByType<GlobalTime>();
    }

    void Update()
    {
        t += Time.deltaTime * manager.active;
        
        if (t >= catchRate)
        {
            colorIndex++;
            colorIndex %= (int)albumSize;
            t = 0f;
            
            if (manager.active != 1)
            {
                listOfShoots.Add(Instantiate(subject, subject.transform.position, subject.transform.rotation));
                // listOfShoots.GetComponent<Animator>().enabled = false;
                
                if (listOfShoots.Count > albumSize)
                {
                    Destroy(listOfShoots[0]);
                    listOfShoots.Remove(listOfShoots[0]);
                }
                
                for (int i = 0; i <= listOfShoots[listOfShoots.Count - 1].transform.childCount - 1; i++)
                {
                    Transform child = listOfShoots[listOfShoots.Count - 1].transform.GetChild(i);
                    
                    if (child.GetComponent<SkinnedMeshRenderer>() == true)
                    {
                        SkinnedMeshRenderer skinMesh = child.GetComponent<SkinnedMeshRenderer>();
                        skinMesh.enabled = true;
                        skinMesh.materials[0].SetColor("_MainColor", CalculateColor(colorIndex));
                        skinMesh.materials[1].SetColor("_MainColor", CalculateColor(colorIndex));
                    }
                    // child.GetComponent<SkinnedMeshRenderer>().materials[2].SetColor("_MainColor", CalculateColor(listOfShoots.Count));
                }
            }
            
            else
            {
                t = catchRate / 4 * 3;
                
                for (int i = 0; i < listOfShoots.Count; i++)
                {
                    if (listOfShoots.Count > 0)
                    {
                        Destroy(listOfShoots[0]);
                        listOfShoots.Remove(listOfShoots[0]);
                    }
                }
            }
        }
    }

    Color CalculateColor(float index)
    {
        float value = index / albumSize;
        
        bool sub33 = value <= 1f/3f;
        bool post67 = value >= 2f/3f;

        if (sub33)
            return Color.Lerp(colors[0], colors[1], value * 3f);
        
        else if (!post67)
            return Color.Lerp(colors[1], colors[2], (value - 1f/3f) * 3f);
        
        else
            return Color.Lerp(colors[2], colors[0], (value - 2f/3f) * 3f);
    }
}