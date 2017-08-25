using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace ARMSim.Preferences.PreferencesForm.Wizard
{
    public class WizardPagesCollection : CollectionBase
    {
        private Wizard owner = null;

        public WizardPagesCollection(Wizard owner)
        {
            this.owner = owner;
        }

        public WizardPage this[int index]
        {
            get
            {
                return (WizardPage)base.List[index];
            }
            set
            {
                base.List[index] = value;
            }
        }

        public int Add(WizardPage value)
        {
            int result = List.Add(value);
            return result;
        }

        /// <summary>
        /// Adds the elements of an array of WizardPage objects to the end of the WizardPagesCollection.  
        /// </summary>
        /// <param name="pages">An array on WizardPage objects to be added.
        /// The array itself cannot be null, but it can contain elements that are null.</param>
        public void AddRange(WizardPage[] pages)
        {
            // Use external to validate and add each entry
            foreach (WizardPage page in pages)
            {
                this.Add(page);
            }
        }

        /// <summary>
        /// Searches for the specified WizardPage and returns the zero-based index
        /// of the first occurrence in the entire WizardPagesCollection.
        /// </summary>
        /// <param name="value">A WizardPage object to locate in the WizardPagesCollection.
        /// The value can be null.</param>
        /// <returns></returns>
        public int IndexOf(WizardPage value)
        {
            return List.IndexOf(value);
        }

        /// <summary>
        /// Inserts an element into the WizardPagesCollection at the specified index.
        /// </summary>
        /// <param name="index">An Integer value representing the zero-based index at which value should be inserted.</param>
        /// <param name="value">A WizardPage object to insert. The value can be null.</param>
        public void Insert(int index, WizardPage value)
        {
            // insert the item
            List.Insert(index, value);
        }

        /// <summary>
        /// Removes the first occurrence of a specific object from the WizardPagesCollection.
        /// </summary>
        /// <param name="value">A WizardPage object to remove. The value can be null.</param>
        public void Remove(WizardPage value)
        {
            // remove the item
            List.Remove(value);
        }

        /// <summary>
        /// Determines whether an element is in the WizardPagesCollection.  
        /// </summary>
        /// <param name="value">The WizardPage object to locate. The value can be null.</param>
        /// <returns>true if item is found in the WizardPagesCollection; otherwise, false.</returns>
        public bool Contains(WizardPage value)
        {
            return List.Contains(value);
        }

        /// <summary>
        /// Performs additional custom processes after inserting a new element into the WizardPagesCollection instance.
        /// </summary>
        /// <param name="index">The zero-based index at which to insert value.</param>
        /// <param name="value">The new value of the element at index.</param>
        protected override void OnInsertComplete(int index, object value)
        {
            // call base class
            base.OnInsertComplete(index, value);

            // reset current page index
            this.owner.SelectedIndex = index;
        }

        /// <summary>
        /// Performs additional custom processes after removing an element from the System.Collections.CollectionBase instance.
        /// </summary>
        /// <param name="index">The zero-based index at which value can be found.</param>
        /// <param name="value">The value of the element to remove from index.</param>
        protected override void OnRemoveComplete(int index, object value)
        {
            // call base class
            base.OnRemoveComplete(index, value);

            // check if removing current page
            if (this.owner.SelectedIndex == index)
            {
                // check if at the end of the list
                if (index < InnerList.Count)
                {
                    this.owner.SelectedIndex = index;
                }
                else
                {
                    this.owner.SelectedIndex = InnerList.Count - 1;
                }
            }
        }//OnRemoveComplete
    }//class WizardPagesCollection
}
