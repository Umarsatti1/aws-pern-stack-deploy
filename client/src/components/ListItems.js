import React, { Fragment, useEffect, useState } from "react";
import EditItems from "./EditItems";

const ListItems = () => {

    const [lists, setLists] = useState([]);

    const deleteList = async(id) => {
        try {
            const deleteList = await fetch(`http://localhost:5000/todos/${id}`, {
                method: "DELETE"
            });

            setLists(lists.filter(list => list.todo_id !== id));
        } catch (err) {
            console.error(err.message);
        }
    }

    const getLists = async () => {
        try {
            const response = await fetch("http://localhost:5000/todos");
            const jsonData = await response.json();

            setLists(jsonData);
        } catch (err) {
            console.error(err.message);
        }
    }

    useEffect(() => {
        getLists();
    }, []);

    return (
        <Fragment>
            <table class="table mt-5 text-center">
                <thead class="table-success">
                    <tr>
                        <th scope="col">Description</th>
                        <th scope="col">Edit</th>
                        <th scope="col">Delete</th>
                    </tr>
                </thead>
                <tbody>
                    {/*<tr>
                        <td>John</td>
                        <td>Mark</td>
                        <td>Otto</td>
                    </tr>*/}
                    {lists.map(list => (
                        <tr key={list.todo_id}>
                            <td>{list.description}</td>
                            <td>
                                <EditItems list={list}/>
                            </td>
                            <td>
                                <button className="btn btn-danger" onClick={() => deleteList(list.todo_id)}>
                                    Delete
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </Fragment>
    )
};

export default ListItems;
