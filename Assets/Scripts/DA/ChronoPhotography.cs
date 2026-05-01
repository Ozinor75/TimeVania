using System;
using System.Collections.Generic;
using NUnit.Framework.Internal;
using UnityEngine;
using UnityEngine.Serialization;

public class ChronoPhotography : MonoBehaviour
{
    
    private GlobalTime manager;
    private float t;
    private int colorIndex;
    public float catchRate;
    public float albumSize;
    public Material photoMaterial;
    public List<Color> colors = new List<Color>(3);
    
    public List<GameObject> subjects;
    private List<List<GameObject>> listOfShoots = new List<List<GameObject>>();
    private Transform parent;
    
    private void Start()
    {
        t = 0;
        manager = FindFirstObjectByType<GlobalTime>();

        for (int i = 0; i < subjects.Count; i++)
        {
            listOfShoots.Add(new List<GameObject>());
        }
    }

    void Update()
    {
        t += Time.deltaTime * manager.active;

        if (t >= catchRate)
        {
            t = 0f;
            
            colorIndex++;
            colorIndex %= (int)albumSize;
            
            if (manager.active != 1)
            {
                for (int i = 0; i < listOfShoots.Count; i++)
                {
                    Transform parent = subjects[i].transform.parent;
                    listOfShoots[i].Add(Instantiate(subjects[i], parent.position, parent.rotation));
                    listOfShoots[i][listOfShoots[i].Count - 1].transform.localScale *= 18;
                    listOfShoots[i][listOfShoots[i].Count - 1].GetComponent<MeshRenderer>().enabled = true;
                    
                    listOfShoots[i][listOfShoots[i].Count - 1].GetComponent<MeshRenderer>().material.SetColor("_MainColor", CalculateColor(colorIndex));
                    
                    if (listOfShoots[i].Count > albumSize)
                    {
                        Destroy(listOfShoots[i][0]);
                        listOfShoots[i].Remove(listOfShoots[i][0]);
                    }
                }
            }
            
            else
            {
                for (int i = 0; i < listOfShoots.Count; i++)
                {
                    if (listOfShoots[i].Count > 0)
                    {
                        t += listOfShoots[i].Count / albumSize;
                        Destroy(listOfShoots[i][0]);
                        listOfShoots[i].Remove(listOfShoots[i][0]);
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